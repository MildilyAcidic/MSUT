local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

type Node = Types.Node
type Levels = Types.Levels
type Balances = Types.Balances

local UpgradeTree = {}

UpgradeTree.nodes = {

	{
		id = "root",
		name = "Root",
		requires = {},
		maxLevel = 10,
		effects = {
			sources = {
				{
					id = "rootTap",
					currency = "primary",
					kind = "click",
					tags = { "starter" },
					base = 1,
				},
			},
		},
		baseCost = { primary = 10 },
		costMult = 1.15,
		col = 0,
		row = 0,
	},

	{
		id = "boost",
		name = "Boost",
		requires = { { id = "root", level = 5 } },
		maxLevel = 10,
		effects = {

			modifiers = {
				{ layer = "Increased" :: Types.Layer, value = 0.10, scope = { tags = { "starter" } } },
			},
		},
		baseCost = { primary = 100 },
		costMult = 1.3,
		col = 1,
		row = 0,
	},
} :: { Node }

UpgradeTree.byId = {} :: { [string]: Node }
for _, node in UpgradeTree.nodes do
	assert(UpgradeTree.byId[node.id] == nil, `duplicate upgrade id: {node.id}`)
	UpgradeTree.byId[node.id] = node
end

function UpgradeTree.levelOf(levels: Levels, id: string): number
	return levels[id] or 0
end

function UpgradeTree.costFor(node: Node, currentLevel: number): { [string]: number }
	return {}
end

function UpgradeTree.isUnlocked(node: Node, levels: Levels): boolean
	return true
end

function UpgradeTree.isMaxed(node: Node, levels: Levels): boolean
	return UpgradeTree.levelOf(levels, node.id) >= node.maxLevel
end

function UpgradeTree.collectSources(levels: Levels): { Types.Source }
	return {}
end

function UpgradeTree.effectText(node: Node): string
	return ""
end

return UpgradeTree
