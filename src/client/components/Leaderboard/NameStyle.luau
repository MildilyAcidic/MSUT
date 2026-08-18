local NameStyle = {}

export type Style = {
	color: Color3?,
	gradient: ColorSequence?,
	rotation: number?,
}

NameStyle.ATTRIBUTES = {
	gradient = "NameGradient",
	color = "NameColor",
	rotation = "NameGradientRotation",
}

NameStyle.INSTANCE_NAME = "NameGradient"

function NameStyle.resolve(player: Player): Style
	local style: Style = {}

	local gradient = player:GetAttribute(NameStyle.ATTRIBUTES.gradient)
	if typeof(gradient) == "ColorSequence" then
		style.gradient = gradient
	else
		local instance = player:FindFirstChild(NameStyle.INSTANCE_NAME)
		if instance and instance:IsA("UIGradient") then
			style.gradient = instance.Color
			style.rotation = instance.Rotation
		end
	end

	local color = player:GetAttribute(NameStyle.ATTRIBUTES.color)
	if typeof(color) == "Color3" then
		style.color = color
	end

	local rotation = player:GetAttribute(NameStyle.ATTRIBUTES.rotation)
	if typeof(rotation) == "number" then
		style.rotation = rotation
	end

	return style
end

function NameStyle.signature(style: Style): string
	local parts = {}

	if style.color then
		table.insert(parts, tostring(style.color))
	end
	if style.gradient then
		for _, keypoint in style.gradient.Keypoints do
			table.insert(parts, `{keypoint.Time}:{keypoint.Value}`)
		end
	end
	if style.rotation then
		table.insert(parts, tostring(style.rotation))
	end

	return table.concat(parts, ",")
end

function NameStyle.textColor(style: Style, fallback: Color3): Color3
	if style.gradient then
		return Color3.new(1, 1, 1)
	end
	return style.color or fallback
end

return NameStyle
