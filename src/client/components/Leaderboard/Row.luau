local React = require(script.Parent.Parent.Parent.Roact.React)
local Themes = require(script.Parent.Themes)
local Badges = require(script.Parent.Badges)
local NameStyle = require(script.Parent.NameStyle)

type Theme = Themes.Theme
type Badge = Badges.Badge

export type Props = {
	theme: Theme,
	columns: { any },
	nameWidth: number,
	offsets: { number },
	layoutOrder: number,

	label: string,
	values: { [string]: string },
	badges: { Badge }?,
	nameStyle: NameStyle.Style?,

	isHeader: boolean?,
	isLocal: boolean?,
	isSelected: boolean?,
	player: Player?,

	onClicked: ((player: Player) -> ())?,
	onHovered: ((player: Player, hovering: boolean) -> ())?,
}

local function renderBadge(badge: Badge, theme: Theme, order: number, textColor: Color3)
	if not badge.glyph and (not badge.image or badge.image == "") then
		badge = {
			id = badge.id,
			glyph = "?",
			color = Color3.fromRGB(255, 90, 200),
		}
	end

	if badge.glyph then
		return React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(theme.badgeSize, theme.badgeSize),
			LayoutOrder = order,
			Text = badge.glyph,
			TextColor3 = badge.color or textColor,
			FontFace = badge.font or theme.font,
			TextSize = theme.badgeSize,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		})
	end

	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(theme.badgeSize, theme.badgeSize),
		LayoutOrder = order,
		Image = badge.image or "",
		ImageColor3 = badge.color or Color3.new(1, 1, 1),
		ScaleType = Enum.ScaleType.Fit,
	})
end

local function renderCell(
	column: any,
	text: string,
	theme: Theme,
	textColor: Color3,
	font: Font,
	textSize: number,
	x: number
)
	local children: { [string]: any } = {}

	children.layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = if column.align == Enum.TextXAlignment.Left
			then Enum.HorizontalAlignment.Left
			else Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, theme.badgeGap),
	})

	if column.glyph then
		children.icon = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(theme.iconSize, theme.iconSize),
			LayoutOrder = 1,
			Text = column.glyph,
			TextColor3 = column.iconColor or textColor,
			FontFace = column.glyphFont or font,
			TextSize = theme.iconSize,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		})
	elseif column.icon then
		children.icon = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(theme.iconSize, theme.iconSize),
			LayoutOrder = 1,
			Image = column.icon,
			ImageColor3 = column.iconColor or Color3.new(1, 1, 1),
			ScaleType = Enum.ScaleType.Fit,
		})
	end

	children.value = React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 2,
		Text = text,
		TextColor3 = column.color or textColor,

		FontFace = column.font or font,
		TextSize = textSize,
		TextXAlignment = column.align or Enum.TextXAlignment.Right,
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(x, 0),
		Size = UDim2.new(0, column.width, 1, 0),
	}, children)
end

local function Row(props: Props)
	local theme = props.theme
	local hovering, setHovering = React.useState(false)

	local background, transparency, textColor, font, textSize
	if props.isHeader then
		background = theme.headerBackground
		transparency = theme.headerBackgroundTransparency
		textColor = theme.headerTextColor
		font = theme.headerFont
		textSize = theme.headerTextSize
	elseif props.isLocal then
		background = theme.localBackground
		transparency = theme.localTransparency
		textColor = theme.localTextColor
		font = theme.headerFont
		textSize = theme.textSize
	else
		background = theme.rowBackground
		transparency = if hovering or props.isSelected then theme.rowHoverTransparency else theme.rowTransparency
		textColor = theme.textColor
		font = theme.font
		textSize = theme.textSize
	end

	local children: { [string]: any } = {}

	if theme.cornerRadius > 0 then
		children.corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, theme.cornerRadius),
		})
	end

	if not props.isHeader and theme.accentWidth > 0 and (props.isLocal or hovering or props.isSelected) then
		children.accent = React.createElement("Frame", {
			BackgroundColor3 = theme.accentColor,
			BackgroundTransparency = if props.isLocal or props.isSelected then 0 else 0.5,
			BorderSizePixel = 0,
			Size = UDim2.new(0, theme.accentWidth, 1, 0),
		})
	end

	local badgeList = props.badges or {}
	local nameChildren: { [string]: any } = {}

	nameChildren.layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, theme.badgeGap),
	})

	local badgesWidth = #badgeList * (theme.badgeSize + theme.badgeGap)

	local style = props.nameStyle or {}

	local nameInner: { [string]: any } = {
		constraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(math.max(props.nameWidth - badgesWidth, 20), math.huge),
		}),
	}

	if style.gradient then
		nameInner.gradient = React.createElement("UIGradient", {
			Color = style.gradient,
			Rotation = style.rotation or 0,
		})
	end

	nameChildren.name = React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 1,
		Text = props.label,
		TextColor3 = NameStyle.textColor(style, textColor),
		FontFace = font,
		TextSize = textSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, nameInner)

	for index, badge in badgeList do
		nameChildren["badge_" .. badge.id] = renderBadge(badge, theme, index + 1, textColor)
	end

	children.nameCell = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(theme.padding, 0),
		Size = UDim2.new(0, props.nameWidth, 1, 0),
	}, nameChildren)

	for index, column in props.columns do
		children["col_" .. column.key] =
			renderCell(column, props.values[column.key] or "", theme, textColor, font, textSize, props.offsets[index])
	end

	if props.isHeader and theme.dividerTransparency < 1 then
		children.divider = React.createElement("Frame", {
			BackgroundColor3 = theme.dividerColor,
			BackgroundTransparency = theme.dividerTransparency,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, theme.dividerThickness),
		})
	end

	if props.isHeader then
		return React.createElement("Frame", {
			BackgroundColor3 = background,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, theme.rowHeight),
			LayoutOrder = props.layoutOrder,
		}, children)
	end

	return React.createElement("TextButton", {
		BackgroundColor3 = background,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, theme.rowHeight),
		LayoutOrder = props.layoutOrder,
		Text = "",
		AutoButtonColor = false,

		[React.Event.Activated] = function()
			if props.onClicked and props.player then
				props.onClicked(props.player)
			end
		end,
		[React.Event.MouseEnter] = function()
			setHovering(true)
			if props.onHovered and props.player then
				props.onHovered(props.player, true)
			end
		end,
		[React.Event.MouseLeave] = function()
			setHovering(false)
			if props.onHovered and props.player then
				props.onHovered(props.player, false)
			end
		end,
	}, children)
end

return Row
