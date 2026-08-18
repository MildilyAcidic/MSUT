local Badges = {}

export type Badge = {
	id: string,
	image: string?,
	glyph: string?,
	font: Font?,
	color: Color3?,
	order: number?,
	tooltip: string?,
}

export type Provider = (player: Player) -> Badge?

Badges.glyphs = {
	verified = utf8.char(0xE000),
	premium = utf8.char(0xE001),
	robux = utf8.char(0xE002),
	robloxPlus = utf8.char(0xE003),
}

Badges.assets = {
	verified = "",
	premium = "",
	robloxPlus = "",
}

Badges.ORDER = {
	verified = 10,
	robloxPlus = 20,
	premium = 30,
}

Badges.colors = {
	verified = Color3.fromRGB(0, 162, 255),
	robloxPlus = Color3.fromRGB(255, 199, 65),
	premium = Color3.fromRGB(230, 230, 235),
}

Badges.debugAll = false

Badges.ATTRIBUTES = {
	verified = "HasVerified",
	robloxPlus = "RobloxPlus",
	premium = "HasPremium",
}

local function readFlag(player: Player, property: string): boolean
	local ok, value = pcall(function()
		return (player :: any)[property]
	end)
	return ok and value == true
end

local function shouldShow(player: Player, live: boolean, attribute: string): boolean
	if Badges.debugAll then
		return true
	end
	if player:GetAttribute(attribute) == true then
		return true
	end
	return live
end

function Badges.verified(player: Player): Badge?
	if not shouldShow(player, readFlag(player, "HasVerifiedBadge"), Badges.ATTRIBUTES.verified) then
		return nil
	end
	if Badges.assets.verified ~= "" then
		return {
			id = "verified",
			image = Badges.assets.verified,
			order = Badges.ORDER.verified,
			tooltip = "Verified",
		}
	end
	return {
		id = "verified",
		glyph = Badges.glyphs.verified,
		color = Badges.colors.verified,
		order = Badges.ORDER.verified,
		tooltip = "Verified",
	}
end

function Badges.robloxPlus(player: Player): Badge?
	local live = readFlag(player, "HasRobloxSubscription")
	if not shouldShow(player, live, Badges.ATTRIBUTES.robloxPlus) then
		return nil
	end
	if Badges.assets.robloxPlus ~= "" then
		return {
			id = "robloxPlus",
			image = Badges.assets.robloxPlus,
			order = Badges.ORDER.robloxPlus,
			tooltip = "Roblox Plus",
		}
	end
	return {
		id = "robloxPlus",
		glyph = Badges.glyphs.robloxPlus,
		color = Badges.colors.robloxPlus,
		order = Badges.ORDER.robloxPlus,
		tooltip = "Roblox Plus",
	}
end

function Badges.premium(player: Player): Badge?
	if not shouldShow(player, player.MembershipType == Enum.MembershipType.Premium, Badges.ATTRIBUTES.premium) then
		return nil
	end
	if Badges.assets.premium ~= "" then
		return {
			id = "premium",
			image = Badges.assets.premium,
			order = Badges.ORDER.premium,
			tooltip = "Premium",
		}
	end
	return {
		id = "premium",
		glyph = Badges.glyphs.premium,
		color = Badges.colors.premium,
		order = Badges.ORDER.premium,
		tooltip = "Premium",
	}
end

function Badges.fromAttribute(attribute: string, badge: Badge): Provider
	return function(player: Player): Badge?
		if player:GetAttribute(attribute) ~= true then
			return nil
		end
		return badge
	end
end

function Badges.fromGlyph(
	id: string,
	glyph: string,
	font: Font,
	predicate: (player: Player) -> boolean,
	color: Color3?
): Provider
	return function(player: Player): Badge?
		if not predicate(player) then
			return nil
		end
		return { id = id, glyph = glyph, font = font, color = color }
	end
end

function Badges.fromGroupRank(groupId: number, minimumRank: number, badge: Badge): Provider
	return function(player: Player): Badge?
		local ok, rank = pcall(function()
			return player:GetRankInGroup(groupId)
		end)
		if not ok or rank < minimumRank then
			return nil
		end
		return badge
	end
end

Badges.default = { Badges.verified, Badges.robloxPlus } :: { Provider }

function Badges.collect(player: Player, providers: { Provider }?): { Badge }
	local list = {}
	local source = providers or Badges.default
	local count = 0

	for index, provider in source do
		count += 1

		if type(provider) ~= "function" then
			warn(`[Badges] provider {index} is a {type(provider)}, not a function`)
			continue
		end

		local ok, badge = pcall(provider, player)
		if ok and badge then
			table.insert(list, { badge = badge, index = index })
		elseif not ok then
			warn(`[Badges] provider {index} errored: {badge}`)
		end
	end

	if count < #source then
		warn(`[Badges] the providers list has nil entries, check for a misspelled Badges.something`)
	end

	table.sort(list, function(a, b)
		local left = a.badge.order or math.huge
		local right = b.badge.order or math.huge
		if left ~= right then
			return left < right
		end
		return a.index < b.index
	end)

	local result = {}
	for _, entry in list do
		table.insert(result, entry.badge)
	end
	return result
end

return Badges
