--!strict

local types = {}

types.literal = {
	animations = {
		slide = "slide",
		transparent = "transparent",
		bounce = "bounce",
		wiggle = "wiggle",
	},
	dir = {
		["up"] = true,
		["down"] = true
	}
}

export type markup = {
	color : Color3,
	font : string | number,
	size : number,
	xalign : Enum.HorizontalAlignment,
	yalign : Enum.VerticalAlignment,
	scaleDimension : "X" | "Y",
	sizeConstraint : Enum.SizeConstraint,
	interval : number,
	soundid : (number | string)?,
	anim : keyof<typeof(types.literal.animations)>?,
	weight : Enum.FontWeight,
	italic : boolean,
	trans : number,
	zindex : number,
	stroke : boolean,
	underline : boolean,
	strike : boolean,
	mark : boolean,
	shiny : boolean,
	fog : boolean,
	
	rainbow : boolean,
	shake : boolean,
	emitimg : number?,
}

export type attributes = {
	-- ANIMATIONS
	slide : {
		dir : keyof<typeof(types.literal.dir)>,
		offset : number,
		rotation : number
	},
	transparent : {
		strength : number
	},
	bounce : {
		dir : keyof<typeof(types.literal.dir)>,
		offset : number,
	},
	wiggle : {
		freq : number,
		offset : number,
		amp : number
	},

	-- TAGS
	shake : {
		maxoffset : number,
		dur : number,
		loop : boolean
	},
	rainbow : {
		freq : number,
		offset : number
	},
	emitimg : {
		color : Color3,
		aspectratio : number,
		rate : number,
		chance : number,
		lifetime : NumberRange,
		velx : NumberRange,
		vely : NumberRange,
		rotvel : NumberRange,
		accelx : NumberRange,
		accely : NumberRange,
		starttrans : NumberRange,
		endtrans : NumberRange,
		startsize : NumberRange,
		endsize : NumberRange,
		startposx : NumberRange,
		startposy : NumberRange,
		startrot : NumberRange,
	},
	anim : {
		dur : number,
		loop : boolean,
		tweentrans : boolean
	},
	soundid : {
		volume : number
	},
	img : {
		plain : boolean,
		height : number,
		aspectratio : number,
		color : Color3,
		trans : number
	},
	stroke : {
		trans : number?,
		thickness : number,
		color : Color3
	},
	mark : {
		color : Color3,
		trans : number
	},
	fog : {
		color : Color3
	}
}

return types