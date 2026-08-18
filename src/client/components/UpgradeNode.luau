--!strict

--> one node button

local React = require(script.Parent.Parent.Roact.React)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradeTree = require(ReplicatedStorage.Shared.UpgradeTree)
local Theme = require(ReplicatedStorage.Shared.Theme)
local ClientState = require(script.Parent.Parent.ClientState)
local CurrencyText = require(script.Parent.CurrencyText)

export type Props = {
	node: any, --> Types.Node
	position: UDim2,
}

--[[

todo:
show level out of maxLevel
cost is a table of currencies now so render a CurrencyText per entry, with a
fixed amount and not a live binding
style it from Theme.colors for locked, affordable, tooExpensive and maxed
Activated calls ClientState.requestPurchase(node.id)

work the four visual states out from UpgradeTree.isUnlocked, isMaxed and
ClientState.canAfford instead of storing them, cached ui state that disagrees
with the server is exactly the bug the shared computeStats design avoids, so
dont add it back here

]]
local function UpgradeNode(props: Props)
	return nil :: any
end

return UpgradeNode
