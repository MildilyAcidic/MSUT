local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

type Currency = Types.Currency

local IGNORED = {
	Template = true,
}

local Currencies = {}

Currencies.byId = {} :: { [string]: Currency }
Currencies.list = {} :: { Currency }

for _, child in script:GetChildren() do
	if not child:IsA("ModuleScript") or IGNORED[child.Name] then
		continue
	end

	local definition = require(child) :: Currency

	assert(type(definition.id) == "string" and #definition.id > 0, `{child.Name}: missing id`)
	assert(type(definition.name) == "string", `{definition.id}: missing name`)
	assert(type(definition.spendable) == "boolean", `{definition.id}: spendable must be a boolean`)
	assert(Currencies.byId[definition.id] == nil, `duplicate currency id: {definition.id}`)

	Currencies.byId[definition.id] = definition
	table.insert(Currencies.list, definition)
end

table.sort(Currencies.list, function(a, b)
	return (a.order or math.huge) < (b.order or math.huge)
end)

function Currencies.get(id: string): Currency
	local currency = Currencies.byId[id]
	assert(currency, `unknown currency: {id}`)
	return currency
end

function Currencies.exists(id: string): boolean
	return Currencies.byId[id] ~= nil
end

function Currencies.visible(balances: Types.Balances): { Currency }
	return Currencies.list
end

return Currencies
