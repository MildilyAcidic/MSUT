local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)

type StateSnapshot = Types.StateSnapshot

local Sync = {}

function Sync.push(player: Player) end

function Sync.start() end

return Sync
