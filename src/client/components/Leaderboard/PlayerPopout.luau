local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local React = require(script.Parent.Parent.Parent.Roact.React)
local Themes = require(script.Parent.Themes)
local Badges = require(script.Parent.Badges)
local NameStyle = require(script.Parent.NameStyle)

type Theme = Themes.Theme

export type Action = {
	id: string,
	label: string,
	onClick: (player: Player) -> (),
	color: Color3?,

	condition: ((player: Player) -> boolean)?,
}

export type Props = {
	theme: Theme,
	player: Player,
	visible: boolean,
	actions: { Action },
	badges: { Badges.Badge }?,
	nameStyle: NameStyle.Style?,

	columns: { any }?,
	values: { [string]: string }?,

	onClosed: () -> (),
	position: UDim2,
	anchorPoint: Vector2,
}

local function renderNameLine(player: Player, badges: { Badges.Badge }, style: NameStyle.Style, theme: Theme)
	local nameInner: { [string]: any } = {}
	if style.gradient then
		nameInner.gradient = React.createElement("UIGradient", {
			Color = style.gradient,
			Rotation = style.rotation or 0,
		})
	end

	local children: { [string]: any } = {
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, theme.badgeGap),
		}),

		name = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = 1,
			Text = player.DisplayName,
			TextColor3 = NameStyle.textColor(style, theme.textColor),
			FontFace = theme.headerFont,
			TextSize = theme.textSize + 2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		}, nameInner),
	}

	for index, badge in badges do
		children["badge_" .. badge.id] = if badge.glyph
			then React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(theme.badgeSize, theme.badgeSize),
				LayoutOrder = index + 1,
				Text = badge.glyph,
				TextColor3 = badge.color or theme.textColor,
				FontFace = badge.font or theme.font,
				TextSize = theme.badgeSize,
			})
			else React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(theme.badgeSize, theme.badgeSize),
				LayoutOrder = index + 1,
				Image = badge.image or "",
				ImageColor3 = badge.color or Color3.new(1, 1, 1),
				ScaleType = Enum.ScaleType.Fit,
			})
	end

	return children
end

local function StatLine(props: {
	theme: Theme,
	column: any,
	value: string,
	layoutOrder: number,
})
	local theme = props.theme
	local column = props.column

	local valueChildren: { [string]: any } = {
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, theme.badgeGap),
		}),
	}

	if column.glyph then
		valueChildren.icon = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(theme.iconSize, theme.iconSize),
			LayoutOrder = 1,
			Text = column.glyph,
			TextColor3 = column.iconColor or theme.textColor,
			FontFace = column.glyphFont or theme.font,
			TextSize = theme.iconSize,
		})
	elseif column.icon then
		valueChildren.icon = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(theme.iconSize, theme.iconSize),
			LayoutOrder = 1,
			Image = column.icon,
			ImageColor3 = column.iconColor or Color3.new(1, 1, 1),
			ScaleType = Enum.ScaleType.Fit,
		})
	end

	valueChildren.value = React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 2,
		Text = props.value,
		TextColor3 = column.color or theme.textColor,
		FontFace = column.font or theme.headerFont,
		TextSize = theme.textSize,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, theme.rowHeight),
		LayoutOrder = props.layoutOrder,
	}, {
		label = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, 0, 1, 0),
			Text = column.title or column.key,
			TextColor3 = theme.textColor,
			TextTransparency = 0.35,
			FontFace = theme.font,
			TextSize = theme.textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		}),

		value = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0.5, 0, 1, 0),
		}, valueChildren),
	})
end

local function ActionButton(props: {
	theme: Theme,
	action: Action,
	player: Player,
	layoutOrder: number,
})
	local theme = props.theme
	local hovering, setHovering = React.useState(false)

	return React.createElement(
		"TextButton",
		{
			BackgroundColor3 = props.action.color or theme.buttonBackground,
			BackgroundTransparency = if hovering then theme.buttonHoverTransparency else theme.buttonTransparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, theme.buttonHeight),
			LayoutOrder = props.layoutOrder,
			AutoButtonColor = false,
			Text = props.action.label,
			TextColor3 = theme.buttonTextColor,
			FontFace = theme.font,
			TextSize = theme.textSize,

			[React.Event.Activated] = function()
				props.action.onClick(props.player)
			end,
			[React.Event.MouseEnter] = function()
				setHovering(true)
			end,
			[React.Event.MouseLeave] = function()
				setHovering(false)
			end,
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

local function PlayerPopout(props: Props)
	local theme = props.theme
	local player = props.player

	local ref = React.useRef(nil :: any)
	local thumbnail, setThumbnail = React.useState("")

	React.useEffect(function()
		local cancelled = false

		task.spawn(function()
			local ok, content = pcall(function()
				return Players:GetUserThumbnailAsync(
					player.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size100x100
				)
			end)
			if not cancelled and ok then
				setThumbnail(content)
			end
		end)

		return function()
			cancelled = true
		end
	end, { player })

	React.useEffect(function()
		local frame = ref.current
		if not frame then
			return
		end

		local shown = props.position
		local hidden = UDim2.new(shown.X.Scale, shown.X.Offset + theme.popoutSlide, shown.Y.Scale, shown.Y.Offset)

		local info = TweenInfo.new(
			theme.popoutTweenTime,
			Enum.EasingStyle.Quad,
			if props.visible then Enum.EasingDirection.Out else Enum.EasingDirection.In
		)

		local tween = TweenService:Create(frame, info, {
			GroupTransparency = if props.visible then 0 else 1,
			Position = if props.visible then shown else hidden,
		})

		if props.visible then
			frame.Position = hidden
			frame.GroupTransparency = 1
		end

		tween:Play()

		local finished
		if not props.visible then
			finished = tween.Completed:Connect(function()
				props.onClosed()
			end)
		end

		return function()
			tween:Cancel()
			if finished then
				finished:Disconnect()
			end
		end
	end, { props.visible, props.position })

	local children: { [string]: any } = {}

	children.padding = React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, theme.padding),
		PaddingBottom = UDim.new(0, theme.padding),
		PaddingLeft = UDim.new(0, theme.padding),
		PaddingRight = UDim.new(0, theme.padding),
	})

	children.layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, theme.padding),
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

	children.header = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, theme.thumbnailSize),
		LayoutOrder = 1,
	}, {
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, theme.padding),
		}),

		avatar = React.createElement(
			"ImageLabel",
			{
				BackgroundColor3 = theme.rowBackground,
				BackgroundTransparency = 0.9,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(theme.thumbnailSize, theme.thumbnailSize),
				LayoutOrder = 1,
				Image = thumbnail,
				ScaleType = Enum.ScaleType.Fit,
			},
			if theme.cornerRadius > 0
				then {
					corner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, theme.cornerRadius),
					}),
				}
				else nil
		),

		names = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -(theme.thumbnailSize + theme.padding), 1, 0),
			LayoutOrder = 2,
		}, {
			layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			display = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, theme.textSize + 4),
				LayoutOrder = 1,
			}, renderNameLine(player, props.badges or {}, props.nameStyle or {}, theme)),

			username = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, theme.textSize),
				LayoutOrder = 2,
				Text = "@" .. player.Name,
				TextColor3 = theme.textColor,
				TextTransparency = 0.4,
				FontFace = theme.font,
				TextSize = theme.textSize - 2,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			}),
		}),
	})

	local columns = props.columns or {}
	local values = props.values or {}

	local statChildren: { [string]: any } = {}
	local statCount = 0

	for index, column in columns do
		local text = values[column.key]
		if text == nil or text == "" then
			continue
		end
		statCount += 1
		statChildren["stat_" .. column.key] = React.createElement(StatLine, {
			theme = theme,
			column = column,
			value = text,
			layoutOrder = index,
		})
	end

	if statCount > 0 then
		statChildren.layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		children.stats = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 5,
		}, statChildren)

		if theme.dividerTransparency < 1 then
			children.divider = React.createElement("Frame", {
				BackgroundColor3 = theme.dividerColor,
				BackgroundTransparency = theme.dividerTransparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, theme.dividerThickness),
				LayoutOrder = 4,
			})
		end
	end

	for index, action in props.actions do
		local allowed = true
		if action.condition then
			local ok, result = pcall(action.condition, player)
			allowed = ok and result == true
		end

		if allowed then
			children["action_" .. action.id] = React.createElement(ActionButton, {
				theme = theme,
				action = action,
				player = player,
				layoutOrder = 10 + index,
			})
		end
	end

	return React.createElement("CanvasGroup", {
		ref = ref,
		BackgroundColor3 = theme.popoutBackground,
		BackgroundTransparency = theme.popoutTransparency,
		BorderSizePixel = 0,
		AnchorPoint = props.anchorPoint,

		Size = UDim2.new(0, theme.popoutWidth, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		GroupTransparency = 1,
	}, children)
end

return PlayerPopout
