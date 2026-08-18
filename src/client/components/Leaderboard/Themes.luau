local Themes = {}

local function fontOr(name: string, fallback: Enum.Font): Font
	local ok, font = pcall(function()
		return Font.fromEnum((Enum.Font :: any)[name])
	end)
	if ok and font then
		return font
	end
	return Font.fromEnum(fallback)
end

export type Theme = {
	font: Font,
	headerFont: Font,
	textSize: number,
	headerTextSize: number,

	textColor: Color3,
	headerTextColor: Color3,
	localTextColor: Color3,

	background: Color3,
	backgroundTransparency: number,
	strokeColor: Color3,
	strokeTransparency: number,
	strokeThickness: number,

	headerBackground: Color3,
	headerBackgroundTransparency: number,

	rowBackground: Color3,
	rowTransparency: number,
	rowHoverTransparency: number,

	localBackground: Color3,
	localTransparency: number,

	dividerColor: Color3,
	dividerTransparency: number,
	dividerThickness: number,

	cornerRadius: number,
	rowHeight: number,
	rowGap: number,
	padding: number,

	badgeSize: number,
	badgeGap: number,
	iconSize: number,

	arrowSize: number,
	arrowColor: Color3,
	collapseTweenTime: number,

	accentColor: Color3,
	accentWidth: number,

	gradient: boolean,
	gradientTransparency: number,

	popoutWidth: number,
	popoutOffset: number,
	popoutBackground: Color3,
	popoutTransparency: number,
	popoutTweenTime: number,
	popoutSlide: number,

	buttonHeight: number,
	buttonBackground: Color3,
	buttonTransparency: number,
	buttonHoverTransparency: number,
	buttonTextColor: Color3,

	thumbnailSize: number,

	width: number,
	anchorPoint: Vector2,
	position: UDim2,
}

Themes.classic = {
	font = Font.fromEnum(Enum.Font.SourceSans),
	headerFont = Font.fromEnum(Enum.Font.SourceSansBold),
	textSize = 16,
	headerTextSize = 16,

	textColor = Color3.fromRGB(255, 255, 255),
	headerTextColor = Color3.fromRGB(255, 255, 255),
	localTextColor = Color3.fromRGB(255, 255, 255),

	background = Color3.fromRGB(0, 0, 0),
	backgroundTransparency = 0.5,
	strokeColor = Color3.fromRGB(0, 0, 0),
	strokeTransparency = 1,
	strokeThickness = 1,

	headerBackground = Color3.fromRGB(0, 0, 0),
	headerBackgroundTransparency = 0.7,

	rowBackground = Color3.fromRGB(255, 255, 255),
	rowTransparency = 1,
	rowHoverTransparency = 0.9,

	localBackground = Color3.fromRGB(255, 255, 255),
	localTransparency = 0.85,

	dividerColor = Color3.fromRGB(255, 255, 255),
	dividerTransparency = 0.75,
	dividerThickness = 1,

	cornerRadius = 0,
	rowHeight = 22,
	rowGap = 0,
	padding = 6,

	badgeSize = 14,
	badgeGap = 3,
	iconSize = 14,

	arrowSize = 16,
	arrowColor = Color3.fromRGB(255, 255, 255),
	collapseTweenTime = 0.22,

	accentColor = Color3.fromRGB(255, 255, 255),
	accentWidth = 2,

	gradient = true,
	gradientTransparency = 0.15,

	popoutWidth = 190,
	popoutOffset = 6,
	popoutBackground = Color3.fromRGB(0, 0, 0),
	popoutTransparency = 0.35,
	popoutTweenTime = 0.18,
	popoutSlide = 24,

	buttonHeight = 26,
	buttonBackground = Color3.fromRGB(255, 255, 255),
	buttonTransparency = 0.88,
	buttonHoverTransparency = 0.78,
	buttonTextColor = Color3.fromRGB(255, 255, 255),

	thumbnailSize = 48,

	width = 220,
	anchorPoint = Vector2.new(1, 0),
	position = UDim2.new(1, -8, 0, 8),
} :: Theme

Themes.light = {
	font = fontOr("BuilderSans", Enum.Font.Gotham),
	headerFont = fontOr("BuilderSansBold", Enum.Font.GothamBold),
	textSize = 14,
	headerTextSize = 14,

	textColor = Color3.fromRGB(30, 30, 35),
	headerTextColor = Color3.fromRGB(30, 30, 35),
	localTextColor = Color3.fromRGB(15, 15, 20),

	background = Color3.fromRGB(250, 250, 252),
	backgroundTransparency = 0.1,
	strokeColor = Color3.fromRGB(0, 0, 0),
	strokeTransparency = 0.85,
	strokeThickness = 1,

	headerBackground = Color3.fromRGB(230, 232, 238),
	headerBackgroundTransparency = 0.15,

	rowBackground = Color3.fromRGB(0, 0, 0),
	rowTransparency = 1,
	rowHoverTransparency = 0.94,

	localBackground = Color3.fromRGB(80, 130, 255),
	localTransparency = 0.85,

	dividerColor = Color3.fromRGB(0, 0, 0),
	dividerTransparency = 0.88,
	dividerThickness = 1,

	cornerRadius = 0,
	rowHeight = 22,
	rowGap = 0,
	padding = 6,

	badgeSize = 14,
	badgeGap = 3,
	iconSize = 14,

	arrowSize = 16,
	arrowColor = Color3.fromRGB(30, 30, 35),
	collapseTweenTime = 0.22,

	accentColor = Color3.fromRGB(80, 130, 255),
	accentWidth = 2,

	gradient = false,
	gradientTransparency = 0.1,

	popoutWidth = 190,
	popoutOffset = 6,
	popoutBackground = Color3.fromRGB(250, 250, 252),
	popoutTransparency = 0.05,
	popoutTweenTime = 0.18,
	popoutSlide = 24,

	buttonHeight = 26,
	buttonBackground = Color3.fromRGB(80, 130, 255),
	buttonTransparency = 0.85,
	buttonHoverTransparency = 0.7,
	buttonTextColor = Color3.fromRGB(25, 30, 45),

	thumbnailSize = 48,

	width = 220,
	anchorPoint = Vector2.new(1, 0),
	position = UDim2.new(1, -8, 0, 8),
} :: Theme

function Themes.extend(base: Theme, overrides: { [string]: any }): Theme
	local result = table.clone(base :: any)
	for key, value in overrides do
		result[key] = value
	end
	return result :: any
end

return Themes
