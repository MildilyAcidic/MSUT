--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

return {
	id = "primary",
	name = "Primary",
	spendable = true,
	order = 1,

	display = {
		font = "numeric",
		color = Color3.fromRGB(255, 255, 255),
		size = 24,
		notation = "short",
	},

	contexts = {
		surface = { size = 64 },
		tooltip = { notation = "full" },
	},
} :: Types.Currency
