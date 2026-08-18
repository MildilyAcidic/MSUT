local React = require(script.Parent.Parent.Roact.React)
local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrencyDisplay = require(ReplicatedStorage.Shared.CurrencyDisplay)
local ClientState = require(script.Parent.Parent.ClientState)

local function useCurrencyBinding(currencyId: string, context: string?): any
	return nil :: any
end

return useCurrencyBinding
