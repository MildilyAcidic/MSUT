--!strict

local TextService = game:GetService("TextService")

local types = require(script.Parent.Types)
local config = require(script.Parent.Config)

local util = {}

local function deepCopy<T>(tbl : T) : T
	if type(tbl) == 'table' then
		local copy : any = {}
		
		for k, v in next, tbl, nil do
			copy[deepCopy(k)] = deepCopy(v)
		end
		
		setmetatable(copy, deepCopy(getmetatable(tbl :: any)))
		
		return copy
	else
		return tbl
	end
end
util.deepCopy = deepCopy

util.getWidthOfChildren = function(instance : GuiObject) : number
	local width = 0
	
	for _, v in pairs(instance:GetChildren()) do
		if v:IsA("GuiObject") then
			width += v.AbsoluteSize.X
		end
	end
	
	return width
end

util.updateMarkup = function(
	base : types.markup,
	new : types.markup
) : types.markup
	local previous = {}

	for k, value in pairs(new :: any) do
		previous[k] = (base :: any)[k];
		(base :: any)[k] = value
	end

	return previous :: types.markup
end

util.updateAttributes = function(
	base : types.attributes,
	new : types.attributes
) : types.attributes
	local previous = {}

	for obj, attributes in pairs(new :: {[string] : {[string] : any}}) do
		for attribute, value in pairs(attributes) do
			if not previous[obj] then
				previous[obj] = {}
			end
			
			previous[obj][attribute] = (base :: any)[obj][attribute];
			(base :: any)[obj][attribute] = value
		end
	end

	return previous :: types.attributes
end

local MAX_RETRIES = 5
local textBoundsCache : {
	[any] : {
		[number] : {
			string : string,
			font : string | number,
			size : number,
			weight : Enum.FontWeight,
			style : Enum.FontStyle,
			textBounds : Vector2
		}
	}	
} = {}
util.fetchTextBounds = function(
	cacheKey : any,
	str : string,
	markup : types.markup,
	proportionalSize : number?
) : Vector2
	local styleEnum = markup.italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal
	
	for _, v in pairs(textBoundsCache) do
		for _, cached in ipairs(v) do
			if cached.string == str then
				if cached.font == markup.font then
					if cached.size == (proportionalSize or markup.size) then
						if cached.weight == markup.weight then
							if cached.style == styleEnum then
								return cached.textBounds
							end
						end
					end
				end
			end
		end
	end
	
	local params = Instance.new("GetTextBoundsParams")
	params.Text = str
	params.Font = typeof(markup.font) == "string"
		and Font.new(markup.font, markup.weight, styleEnum)
		or Font.fromId(markup.font :: number, markup.weight, styleEnum)
	
	params.Size = proportionalSize or markup.size

	local retries = 0
	
	local function fetch() : Vector2
		local success, textBounds = pcall(function()			
			return TextService:GetTextBoundsAsync(params)
		end)
		if success then
			if not textBoundsCache[cacheKey] then
				textBoundsCache[cacheKey] = {}
			end
			
			table.insert(textBoundsCache[cacheKey], {
				string = str,
				font = markup.font,
				size =  proportionalSize or markup.size,
				weight = markup.weight,
				style = styleEnum,
				textBounds = textBounds
			})
			
			return textBounds
		else			
			if retries < MAX_RETRIES then
				retries += 1
				
				return fetch()
			else
				warn("Failed to fetch text bounds: " .. tostring(textBounds))
				
				return Vector2.zero
			end
		end
	end

	return fetch()
end
util.removeTextBoundsCache = function(cacheKey : any)
	textBoundsCache[cacheKey] = nil
end

util.getRandomFromRange = function(range : NumberRange) : number
	return (range.Max - range.Min) * math.random() + range.Min
end

util.stringToNumber = function(str : string) : number
	if tonumber(str) then
		return tonumber(str) :: number
	end

	error(str .. " is not a valid number", 0)
end

util.stringToNumberRange = function(str : string) : NumberRange
	local min, max = string.match(str, "^(%d+),(%d+)$")
	local min, max =
		min and util.stringToNumber(min),
		max and util.stringToNumber(max)
	
	if min and max then
		return NumberRange.new(min, max)
	else
		error(str .. " is not a valid format, expected min,max", 0)
	end
end

util.stringToVector2 = function(str : string) : Vector2
	local x, y = string.match(str, "^(%d+),(%d+)$")
	local x, y =
		x and util.stringToNumber(x),
		y and util.stringToNumber(y)

	if x and y then
		return Vector2.new(x, y)
	else
		error(str .. " is not a valid format, expected x,y", 0)
	end
end

util.stringToBoolean = function(str : string) : boolean
	str = string.lower(str)
	
	if str == "true" or str == "false" then
		return str == "true"
	end
	
	error(str .. " is not a valid boolean", 0)
end

util.stringToColor3 = function(str : string) : Color3
	local r, g, b = string.match(str, "^(%d+),(%d+),(%d+)$")
	local r, g, b =
		r and util.stringToNumber(r),
		g and util.stringToNumber(g),
		b and util.stringToNumber(b)
	
	if r and g and b then
		return Color3.fromRGB(r, g, b)
	else
		error(str .. " is not a valid format, expected r,g,b or a color shortcut", 0)
	end
end

local WEIGHTS_MAP : {[string] : Enum.FontWeight} = {
	["thin"] = Enum.FontWeight.Thin,
	["extralight"] = Enum.FontWeight.ExtraLight,
	["light"] = Enum.FontWeight.Light,
	["regular"] = Enum.FontWeight.Regular,
	["medium"] = Enum.FontWeight.Medium,
	["semibold"] = Enum.FontWeight.SemiBold,
	["bold"] = Enum.FontWeight.Bold,
	["extrabold"] = Enum.FontWeight.ExtraBold,
	["heavy"] = Enum.FontWeight.Heavy,
}
util.stringToFontWeight = function(str : string) : Enum.FontWeight
	return WEIGHTS_MAP[str] or error(str .. " is not a valid member of \"Enum.FontWeight\"", 0)
end

return util
