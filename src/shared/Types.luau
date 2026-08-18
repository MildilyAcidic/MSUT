export type Levels = { [string]: number }
export type Balances = { [string]: number }

export type DisplayStyle = {

	font: string?,
	fontOverride: { family: string | number, weight: Enum.FontWeight, italic: boolean }?,

	color: Color3?,
	size: number?,

	notation: string?,
	decimals: number?,

	prefix: string?,
	suffix: string?,
	icon: string?,

	markup: string?,

	attributes: { [string]: any }?,
}

export type Currency = {
	id: string,
	name: string,
	abbrev: string?,

	spendable: boolean,

	order: number?,

	hiddenUntilEarned: boolean?,

	display: DisplayStyle?,
	contexts: { [string]: DisplayStyle }?,
}

export type Source = {
	id: string,
	currency: string,
	kind: string,
	tags: { string },

	base: number,
	count: number,
}

export type Layer = "Flat" | "Increased" | "More"

export type Scope = {
	currency: string?,
	kind: string?,
	tags: { string }?,
	sourceId: string?,
}

export type Modifier = {
	layer: Layer,
	value: number,
	scope: Scope,
}

export type NodeEffects = {

	sources: { { id: string, currency: string, kind: string, tags: { string }, base: number } }?,

	modifiers: { Modifier }?,
}

export type Node = {
	id: string,
	name: string,

	requires: { { id: string, level: number } },
	maxLevel: number,

	effects: NodeEffects,

	baseCost: { [string]: number },
	costMult: number,

	col: number,
	row: number,
}

export type Output = { [string]: number }

export type Stats = {
	perSecond: Output,
	perClick: Output,
}

export type SaveData = {
	balances: Balances,
	levels: Levels,
	lastSeen: number,
}

export type StateSnapshot = {
	balances: Balances,
	levels: Levels,
	stats: Stats,
}

return {}
