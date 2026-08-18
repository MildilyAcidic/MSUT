local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Currencies = require(ReplicatedStorage.Shared.Currencies)
local Format = require(ReplicatedStorage.Shared.Format)
local Theme = require(ReplicatedStorage.Shared.Theme)
local Types = require(ReplicatedStorage.Shared.Types)

type DisplayStyle = Types.DisplayStyle

local CurrencyDisplay = {}

CurrencyDisplay.defaults = {
	font = "numeric",
	color = Theme.colors.text,
	size = 20,
	notation = "short",
	decimals = 2,
	prefix = "",
	suffix = "",
} :: DisplayStyle

CurrencyDisplay.formatters = {
	short = function(n: number, style: DisplayStyle): string
		return Format.short(n)
	end,

	full = function(n: number, style: DisplayStyle): string
		return tostring(math.floor(n))
	end,

	sci = function(n: number, style: DisplayStyle): string
		return tostring(n)
	end,
} :: { [string]: (number, DisplayStyle) -> string }

function CurrencyDisplay.resolve(currencyId: string, context: string?, overrides: DisplayStyle?): DisplayStyle
	return CurrencyDisplay.defaults
end

function CurrencyDisplay.fontFace(style: DisplayStyle): Font
	if style.fontOverride then
		return Theme.toFontFace(style.fontOverride :: any)
	end
	return Theme.toFontFace(Theme.font(style.font or "numeric"))
end

function CurrencyDisplay.plain(currencyId: string, amount: number, context: string?): string
	return ""
end

function CurrencyDisplay.rich(currencyId: string, amount: number, context: string?): string
	return ""
end

function CurrencyDisplay.hyperTextMarkup(style: DisplayStyle): (any, any)
	return nil, nil
end

return CurrencyDisplay
