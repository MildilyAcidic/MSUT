local React = require(script.Parent.Parent.Roact.React)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrencyDisplay = require(ReplicatedStorage.Shared.CurrencyDisplay)
local useCurrencyBinding = require(script.Parent.Parent.hooks.useCurrencyBinding)

export type Props = {
	currencyId: string,
	context: string?,

	amount: number?,

	layoutOrder: number?,
	size: UDim2?,
	position: UDim2?,
}

local function CurrencyText(props: Props)
	return nil :: any
end

return CurrencyText
