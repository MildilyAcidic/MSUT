--!strict
local React = require(script.Parent.Parent.Roact.React)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradeTree = require(ReplicatedStorage.Shared.UpgradeTree)
local UpgradeNode = require(script.Parent.UpgradeNode)
local Connector = require(script.Parent.Connector)

--[[

todo: a ScrollingFrame or a pannable Frame holding a Connector for each entry in
every nodes requires, and an UpgradeNode for each node placed from col and row

the spacing and node size live here and Connector works out its placement from
the same numbers, so dont write them twice, either export them or pass them down,
two copies of the spacing means lines that miss

the node list is static since its content, so this only changes when levels
change, keep the per node afford check inside UpgradeNode instead of doing it all
here or every purchase re renders the whole tree

]]
local function UpgradeTreeView()
	return nil :: any
end

return UpgradeTreeView
