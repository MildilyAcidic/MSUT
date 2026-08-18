local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local React = require(script.Parent.Parent.Roact.React)
local Themes = require(script.Themes)
local Badges = require(script.Badges)
local Row = require(script.Row)
local NameStyle = require(script.NameStyle)
local PlayerPopout = require(script.PlayerPopout)

type Theme = Themes.Theme
type Action = PlayerPopout.Action

export type Column = {
	key: string,
	title: string?,
	width: number?,
	align: Enum.TextXAlignment?,
	get: ((player: Player) -> any)?,
	format: ((value: any) -> string)?,

	font: Font?,

	glyph: string?,
	glyphFont: Font?,
	icon: string?,
	iconColor: Color3?,
	color: Color3?,
	titleIcon: string?,
	titleGlyph: string?,
}

export type Props = {
	theme: Theme?,
	columns: { Column }?,
	nameTitle: string?,

	badges: { Badges.Provider }?,

	nameStyle: ((player: Player) -> NameStyle.Style)?,

	useDisplayName: boolean?,

	maxRows: number?,
	updateInterval: number?,
	hideDefault: boolean?,

	filter: ((player: Player) -> boolean)?,
	sort: ((a: any, b: any) -> boolean)?,

	popout: boolean?,

	collapsible: boolean?,
	toggleKey: Enum.KeyCode?,
	toggleEnabled: boolean?,
	startCollapsed: boolean?,
	onToggled: ((collapsed: boolean) -> ())?,

	actions: { Action }?,

	onPlayerClicked: ((player: Player) -> ())?,
	onPlayerHovered: ((player: Player, hovering: boolean) -> ())?,
}

local DEFAULT_WIDTH = 60

local function readValue(player: Player, column: Column): any
	if column.get then
		return column.get(player)
	end

	local stats = player:FindFirstChild("leaderstats")
	if not stats then
		return nil
	end

	local entry = stats:FindFirstChild(column.key)
	if entry then
		return (entry :: any).Value
	end
	return nil
end

local function formatValue(value: any, column: Column): string
	if value == nil then
		return ""
	end
	if column.format then
		return column.format(value)
	end
	return tostring(value)
end

local function discoverColumns(): { Column }
	local seen = {}
	local columns = {}

	for _, player in Players:GetPlayers() do
		local stats = player:FindFirstChild("leaderstats")
		if not stats then
			continue
		end
		for _, entry in stats:GetChildren() do
			if not seen[entry.Name] then
				seen[entry.Name] = true
				table.insert(columns, { key = entry.Name, title = entry.Name })
			end
		end
	end

	return columns
end

local function defaultActions(close: () -> ()): { Action }
	return {
		{
			id = "friend",
			label = "Add Friend",

			condition = function(player)
				if player == Players.LocalPlayer then
					return false
				end
				local ok, friends = pcall(function()
					return Players.LocalPlayer:IsFriendsWith(player.UserId)
				end)
				return not (ok and friends)
			end,
			onClick = function(player)
				pcall(function()
					StarterGui:SetCore("PromptSendFriendRequest", player)
				end)
			end,
		},
		{
			id = "close",
			label = "Close",
			onClick = function()
				close()
			end,
		},
	}
end

local function Leaderboard(props: Props)
	local theme = props.theme or Themes.classic
	local interval = props.updateInterval or 0.5

	local selected, setSelected = React.useState(nil :: Player?)
	local open, setOpen = React.useState(false)
	local collapsed, setCollapsed = React.useState(props.startCollapsed == true)

	local containerRef = React.useRef(nil :: any)
	local settled = React.useRef(false)

	local latest = React.useRef(props)
	latest.current = props

	local snapshot, setSnapshot = React.useState({ columns = {}, rows = {} })

	React.useEffect(function()
		local current = latest.current
		if current.hideDefault ~= false then
			pcall(function()
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			end)
		end

		local signature = ""

		local function refresh()
			local props_ = latest.current
			local columns = props_.columns or discoverColumns()

			local rows = {}
			for _, player in Players:GetPlayers() do
				if props_.filter and not props_.filter(player) then
					continue
				end

				local values = {}
				local raw = {}
				for _, column in columns do
					local value = readValue(player, column)
					raw[column.key] = value
					values[column.key] = formatValue(value, column)
				end

				local resolver = props_.nameStyle or NameStyle.resolve
				local ok, style = pcall(resolver, player)

				table.insert(rows, {
					player = player,
					values = values,
					raw = raw,
					badges = Badges.collect(player, props_.badges),
					nameStyle = if ok then style else {},
				})
			end

			local sorter = props_.sort
			if sorter then
				table.sort(rows, sorter)
			elseif #columns > 0 then
				local first = columns[1].key
				table.sort(rows, function(a, b)
					local left = tonumber(a.raw[first])
					local right = tonumber(b.raw[first])
					if left and right and left ~= right then
						return left > right
					end
					return a.player.Name:lower() < b.player.Name:lower()
				end)
			else
				table.sort(rows, function(a, b)
					return a.player.Name:lower() < b.player.Name:lower()
				end)
			end

			local limit = props_.maxRows
			if limit and #rows > limit then
				for index = #rows, limit + 1, -1 do
					rows[index] = nil
				end
			end

			local parts = {}
			for _, entry in rows do
				table.insert(parts, entry.player.Name)
				for _, column in columns do
					table.insert(parts, entry.values[column.key])
				end

				for _, badge in entry.badges do
					table.insert(parts, badge.id)
				end

				table.insert(parts, NameStyle.signature(entry.nameStyle))
			end
			local next_ = table.concat(parts, "\0")

			if next_ ~= signature then
				signature = next_
				setSnapshot({ columns = columns, rows = rows })
			end
		end

		refresh()

		local elapsed = 0
		local connection = RunService.Heartbeat:Connect(function(dt)
			elapsed += dt
			if elapsed < interval then
				return
			end
			elapsed = 0
			refresh()
		end)

		local added = Players.PlayerAdded:Connect(refresh)
		local removing = Players.PlayerRemoving:Connect(function()
			task.defer(refresh)
		end)

		return function()
			connection:Disconnect()
			added:Disconnect()
			removing:Disconnect()

			if current.hideDefault ~= false then
				pcall(function()
					StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
				end)
			end
		end
	end, { interval })

	local layout = React.useMemo(function()
		local columns = snapshot.columns
		local statsWidth = 0
		for _, column in columns do
			statsWidth += column.width or DEFAULT_WIDTH
		end

		local nameWidth = math.max(theme.width - statsWidth - theme.padding * 2, 40)

		local offsets = {}
		local x = theme.padding + nameWidth
		for index, column in columns do
			offsets[index] = x
			x += column.width or DEFAULT_WIDTH
		end

		local normalized = {}
		for index, column in columns do
			normalized[index] = {
				key = column.key,
				title = column.title or column.key,
				width = column.width or DEFAULT_WIDTH,
				align = column.align,
				font = column.font,
				glyph = column.glyph,
				glyphFont = column.glyphFont,
				icon = column.icon,
				iconColor = column.iconColor,
				color = column.color,
				titleIcon = column.titleIcon,
				titleGlyph = column.titleGlyph,
			}
		end

		return { columns = normalized, offsets = offsets, nameWidth = nameWidth }
	end, { snapshot, theme })

	local children: { [string]: any } = {}

	children.layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, theme.rowGap),
	})

	if theme.cornerRadius > 0 then
		children.corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, theme.cornerRadius),
		})
	end

	if theme.strokeTransparency < 1 then
		children.stroke = React.createElement("UIStroke", {
			Color = theme.strokeColor,
			Transparency = theme.strokeTransparency,
			Thickness = theme.strokeThickness,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
	end

	if theme.gradient then
		children.gradient = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, theme.gradientTransparency),
			}),
		})
	end

	local toggle = React.useCallback(function()
		setCollapsed(function(current)
			local next_ = not current
			if props.onToggled then
				props.onToggled(next_)
			end
			return next_
		end)
	end, { props.onToggled })

	React.useEffect(function()
		if props.toggleEnabled == false then
			return
		end

		local key = props.toggleKey or Enum.KeyCode.Tab

		local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed or input.KeyCode ~= key then
				return
			end
			toggle()
		end)

		return function()
			connection:Disconnect()
		end
	end, { props.toggleKey, props.toggleEnabled, toggle })

	React.useEffect(function()
		if collapsed then
			setOpen(false)
		end
	end, { collapsed })

	React.useEffect(function()
		local container = containerRef.current
		if not container then
			return
		end

		local hidden = UDim2.new(1, theme.width, theme.position.Y.Scale, theme.position.Y.Offset)
		local target = if collapsed then hidden else theme.position

		if not settled.current then
			settled.current = true
			container.Position = target
			return
		end

		local tween = TweenService:Create(
			container,
			TweenInfo.new(theme.collapseTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = target }
		)
		tween:Play()

		return function()
			tween:Cancel()
		end
	end, { collapsed, theme })

	local handleRowClicked = React.useCallback(function(player: Player)
		if props.onPlayerClicked then
			props.onPlayerClicked(player)
		end
		if props.popout == false then
			return
		end

		if selected == player and open then
			setOpen(false)
		else
			setSelected(player)
			setOpen(true)
		end
	end, { props.onPlayerClicked, props.popout, selected, open })

	local headerColumns = {}
	local headerValues = {}
	for index, column in layout.columns do
		local hasTitleIcon = column.titleIcon ~= nil or column.titleGlyph ~= nil
		headerValues[column.key] = if hasTitleIcon then "" else column.title

		local copy = table.clone(column)
		copy.icon = column.titleIcon
		copy.glyph = column.titleGlyph
		headerColumns[index] = copy
	end

	children.header = React.createElement(Row, {
		theme = theme,
		columns = headerColumns,
		offsets = layout.offsets,
		nameWidth = layout.nameWidth,
		layoutOrder = 0,
		label = props.nameTitle or "Players",
		values = headerValues,
		isHeader = true,
	})

	local localPlayer = Players.LocalPlayer
	for index, entry in snapshot.rows do
		children["row_" .. entry.player.Name] = React.createElement(Row, {
			theme = theme,
			columns = layout.columns,
			offsets = layout.offsets,
			nameWidth = layout.nameWidth,
			layoutOrder = index,
			label = if props.useDisplayName == false then entry.player.Name else entry.player.DisplayName,
			values = entry.values,
			badges = entry.badges,
			nameStyle = entry.nameStyle,
			isLocal = entry.player == localPlayer,
			isSelected = entry.player == selected and open,
			player = entry.player,
			onClicked = handleRowClicked,
			onHovered = props.onPlayerHovered,
		})
	end

	local showArrow = props.collapsible ~= false
	local arrowSpace = if showArrow then theme.arrowSize else 0

	local shell: { [string]: any } = {
		panel = React.createElement("Frame", {
			BackgroundColor3 = theme.background,
			BackgroundTransparency = theme.backgroundTransparency,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(arrowSpace, 0),
			Size = UDim2.fromOffset(theme.width, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, children),
	}

	if showArrow then
		shell.arrow = React.createElement(
			"TextButton",
			{
				BackgroundColor3 = theme.headerBackground,
				BackgroundTransparency = theme.headerBackgroundTransparency,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.fromOffset(theme.arrowSize, theme.rowHeight),
				Text = if collapsed then "<" else ">",
				TextColor3 = theme.arrowColor,
				FontFace = theme.headerFont,
				TextSize = theme.headerTextSize,
				AutoButtonColor = false,

				[React.Event.Activated] = toggle,
			},
			if theme.cornerRadius > 0
				then {
					corner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, theme.cornerRadius),
					}),
				}
				else nil
		)
	end

	local container = React.createElement("Frame", {
		ref = containerRef,
		BackgroundTransparency = 1,
		AnchorPoint = theme.anchorPoint,
		Size = UDim2.fromOffset(arrowSpace + theme.width, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	}, shell)

	local root: { [string]: any } = { container = container }

	if selected then
		local entry
		for _, candidate in snapshot.rows do
			if candidate.player == selected then
				entry = candidate
				break
			end
		end

		local popoutPosition = UDim2.new(
			theme.position.X.Scale,
			theme.position.X.Offset - theme.width - arrowSpace - theme.popoutOffset,
			theme.position.Y.Scale,
			theme.position.Y.Offset
		)

		root.popout = React.createElement(PlayerPopout, {
			theme = theme,
			player = selected,
			visible = open,
			position = popoutPosition,
			anchorPoint = theme.anchorPoint,
			columns = layout.columns,
			values = if entry then entry.values else nil,
			badges = if entry then entry.badges else nil,
			nameStyle = if entry then entry.nameStyle else nil,
			actions = props.actions or defaultActions(function()
				setOpen(false)
			end),
			onClosed = function()
				setSelected(nil)
			end,
		})
	end

	return React.createElement(React.Fragment, nil, root)
end

return Leaderboard
