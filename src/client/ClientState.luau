local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

type StateSnapshot = Types.StateSnapshot

local ClientState = {}

ClientState.balances = {} :: Types.Balances
ClientState.levels = {} :: Types.Levels
ClientState.stats = { perSecond = {}, perClick = {} } :: Types.Stats

ClientState.changed = nil :: any

ClientState.ticked = nil :: any

function ClientState.applySnapshot(snapshot: StateSnapshot) end

function ClientState.predict(dt: number) end

function ClientState.tap() end

function ClientState.requestPurchase(nodeId: string) end

function ClientState.canAfford(cost: { [string]: number }): boolean
	return false
end

function ClientState.start() end

return ClientState
