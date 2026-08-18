local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

type Stats = Types.Stats

local Economy = {}

local statsCache: { [Player]: Stats } = {}

function Economy.refreshStats(player: Player) end

function Economy.getStats(player: Player): Stats?
	return statsCache[player]
end

function Economy.grant(player: Player, currency: string, amount: number): number
	return 0
end

function Economy.balanceOf(player: Player, currency: string): number
	return 0
end

function Economy.trySpend(player: Player, cost: { [string]: number }): boolean
	return false
end

function Economy.handleClick(player: Player) end

function Economy.accrue(player: Player, seconds: number, multiplier: number) end

function Economy.start() end

return Economy
