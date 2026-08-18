local UpgradeService = {}

export type PurchaseResult = "Ok" | "UnknownNode" | "Locked" | "Maxed" | "TooPoor" | "NotLoaded"

function UpgradeService.tryPurchase(player: Player, nodeId: string): PurchaseResult
	return "NotLoaded"
end

function UpgradeService.start() end

return UpgradeService
