local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

type Modifier = Types.Modifier
type Source = Types.Source
type Scope = Types.Scope
type Levels = Types.Levels
type Balances = Types.Balances
type Stats = Types.Stats

local Modifiers = {}

function Modifiers.matches(modifier: Modifier, source: Source): boolean
	return false
end

function Modifiers.apply(source: Source, modifiers: { Modifier }): number
	return 0
end

export type Provider = (levels: Levels, balances: Balances) -> { Modifier }

Modifiers.providers = {} :: { Provider }

function Modifiers.registerProvider(provider: Provider)
	table.insert(Modifiers.providers, provider)
end

function Modifiers.fromUpgrades(levels: Levels, balances: Balances): { Modifier }
	return {}
end

function Modifiers.fromBalances(levels: Levels, balances: Balances): { Modifier }
	return {}
end

function Modifiers.computeStats(levels: Levels, balances: Balances): Stats
	return {
		perSecond = {},
		perClick = {},
	}
end

function Modifiers.explain(source: Source, modifiers: { Modifier }): { any }
	return {}
end

return Modifiers
