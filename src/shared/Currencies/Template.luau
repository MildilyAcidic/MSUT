local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

return {
	id = "template",
	name = "Template",
	abbrev = "TPL",

	spendable = true,

	order = 100,
	hiddenUntilEarned = false,

	display = {
		font = "numeric",

		color = Color3.fromRGB(255, 220, 120),
		size = 24,

		notation = "short",
		decimals = 2,

		prefix = "",
		suffix = "",
	},

	contexts = {
		surface = { size = 64 },
		tooltip = { size = 16, notation = "full" },
	},
} :: Types.Currency
