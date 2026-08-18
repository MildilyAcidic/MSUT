local Theme = {}

export type FontSpec = {
	family: string | number,
	weight: Enum.FontWeight,
	italic: boolean,
}

Theme.fonts = {
	display = {
		family = "rbxasset://fonts/families/FredokaOne.json",
		weight = Enum.FontWeight.Bold,
		italic = false,
	},
	numeric = {
		family = "rbxasset://fonts/families/FredokaOne.json",
		weight = Enum.FontWeight.Regular,
		italic = false,
	},
	body = {
		family = "rbxasset://fonts/families/GothamSSm.json",
		weight = Enum.FontWeight.Regular,
		italic = false,
	},
} :: { [string]: FontSpec }

Theme.colors = {
	text = Color3.fromRGB(255, 255, 255),
	muted = Color3.fromRGB(170, 170, 180),
	locked = Color3.fromRGB(110, 110, 120),
	affordable = Color3.fromRGB(120, 235, 140),
	tooExpensive = Color3.fromRGB(235, 120, 120),
} :: { [string]: Color3 }

function Theme.font(name: string): FontSpec
	local spec = Theme.fonts[name]
	assert(spec, `unknown font: {name}`)
	return spec
end

function Theme.toFontFace(spec: FontSpec): Font
	local style = if spec.italic then Enum.FontStyle.Italic else Enum.FontStyle.Normal
	if typeof(spec.family) == "string" then
		return Font.new(spec.family :: string, spec.weight, style)
	end
	return Font.fromId(spec.family :: number, spec.weight, style)
end

return Theme
