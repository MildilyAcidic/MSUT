local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Shared.Types)
local ProfileStore = require(script.Parent.ProfileStore)

type SaveData = Types.SaveData

local TEMPLATE: SaveData = {
	balances = {},
	levels = {},
	lastSeen = 0,
}

local Store = ProfileStore.New("PlayerData", TEMPLATE)

local PlayerData = {}

local profiles: { [Player]: any } = {}

PlayerData.onLoaded = nil :: any
PlayerData.onReleased = nil :: any

function PlayerData.load(player: Player) end

function PlayerData.get(player: Player): SaveData?
	local profile = profiles[player]
	return if profile then profile.Data else nil
end

function PlayerData.isLoaded(player: Player): boolean
	return profiles[player] ~= nil
end

function PlayerData.release(player: Player) end

function PlayerData.start() end

return PlayerData
