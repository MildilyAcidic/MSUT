--!strict

local types = require(script.Parent.Types)

local config = {}

-- color shorcuts used for color values of markups or attributes
config.COLOR_SHORTCUTS = {} :: {[string] : Color3}
config.COLOR_SHORTCUTS.white        = Color3.fromRGB(255, 255, 255)
config.COLOR_SHORTCUTS.black        = Color3.fromRGB(0, 0, 0)
config.COLOR_SHORTCUTS.red          = Color3.fromRGB(255, 70, 70)
config.COLOR_SHORTCUTS.darkred      = Color3.fromRGB(150, 0, 0)
config.COLOR_SHORTCUTS.lightred     = Color3.fromRGB(255, 170, 170)
config.COLOR_SHORTCUTS.green        = Color3.fromRGB(70, 255, 70)
config.COLOR_SHORTCUTS.darkgreen    = Color3.fromRGB(0, 120, 0)
config.COLOR_SHORTCUTS.lightgreen   = Color3.fromRGB(170, 255, 170)
config.COLOR_SHORTCUTS.blue         = Color3.fromRGB(70, 130, 255)
config.COLOR_SHORTCUTS.darkblue     = Color3.fromRGB(0, 70, 160)
config.COLOR_SHORTCUTS.lightblue    = Color3.fromRGB(170, 210, 255)
config.COLOR_SHORTCUTS.yellow       = Color3.fromRGB(255, 199, 32)
config.COLOR_SHORTCUTS.darkyellow   = Color3.fromRGB(170, 150, 0)
config.COLOR_SHORTCUTS.lightyellow  = Color3.fromRGB(255, 250, 170)
config.COLOR_SHORTCUTS.orange       = Color3.fromRGB(255, 140, 40)
config.COLOR_SHORTCUTS.darkorange   = Color3.fromRGB(200, 100, 0)
config.COLOR_SHORTCUTS.lightorange  = Color3.fromRGB(255, 200, 140)
config.COLOR_SHORTCUTS.purple       = Color3.fromRGB(170, 70, 255)
config.COLOR_SHORTCUTS.darkpurple   = Color3.fromRGB(100, 0, 180)
config.COLOR_SHORTCUTS.lightpurple  = Color3.fromRGB(220, 180, 255)
config.COLOR_SHORTCUTS.pink         = Color3.fromRGB(255, 100, 200)
config.COLOR_SHORTCUTS.darkpink     = Color3.fromRGB(180, 0, 100)
config.COLOR_SHORTCUTS.lightpink    = Color3.fromRGB(255, 180, 230)
config.COLOR_SHORTCUTS.cyan         = Color3.fromRGB(100, 220, 255)
config.COLOR_SHORTCUTS.darkcyan     = Color3.fromRGB(0, 150, 180)
config.COLOR_SHORTCUTS.lightcyan    = Color3.fromRGB(180, 240, 255)
config.COLOR_SHORTCUTS.gray         = Color3.fromRGB(150, 150, 150)
config.COLOR_SHORTCUTS.darkgray     = Color3.fromRGB(80, 80, 80)
config.COLOR_SHORTCUTS.lightgray    = Color3.fromRGB(220, 220, 220)

-- min possible interval between typewriter sounds
config.MIN_TYPEWRITER_SFX_INTERVAL = .065

-- fraction of the width of the container
-- any word wider than this value which doesn't fit on the current row will be split instead
-- of fully moved to a new row
config.MAX_WORD_WIDTH_FRACTION = .3

-- the max amount of characters of a render's text displayed for debugging when overflowing
config.DEBUG_OVERFLOW_MAX_TEXT_LENGTH = 40

-- default markup values for all objects (MUST INCLUDE ALL EXISTING MARKUPS!)
config.DEFAULT_MARKUP = {
	color = Color3.new(1, 1, 1),
	font = "rbxasset://fonts/families/FredokaOne.json",
	size = 16,
	xalign = Enum.HorizontalAlignment.Left,
	yalign = Enum.VerticalAlignment.Top,
	scaleDimension = "Y",
	sizeConstraint = Enum.SizeConstraint.RelativeXY,
	interval = .015,
	soundid = nil,
	anim = "slide",
	weight = Enum.FontWeight.Regular,
	italic = false,
	trans = 0,
	zindex = 1,
	rainbow = false,
	shake = false,
	emitimg = nil,
	stroke = false,
	underline = false,
	strike = false,
	shiny = false,
	fog = false
} :: types.markup

-- default attribute values for markups or values for all objects (MUST INCLUDE ALL EXISTING ATTRIBUTES!)
config.DEFAULT_ATTRIBUTES = {
	-- ANIMATIONS
	slide = {
		dir = "down", 
		offset = .75,
		rotation = 55,
	},
	transparent = {
		strength = 1,
	},
	bounce = {
		dir = "down",
		offset = .75,
	},
	wiggle = {
		freq = .75,
		offset = .12,
		amp = .3,
	},
	
	-- TAGS
	shake = {
		maxoffset = .05,
		dur = 2,
		loop = false
	},
	rainbow = {
		freq = .5,
		offset = 0.05,
	},
	emitimg = {
		color = Color3.fromRGB(255, 255, 255),
		aspectratio = 1,
		rate = 4,
		chance = 25,
		lifetime = NumberRange.new(1, 3),
		velx = NumberRange.new(-.25, .25),
		vely = NumberRange.new(-1.25, -1),
		rotvel = NumberRange.new(-70, 70),
		accelx = NumberRange.new(-.2, .2),
		accely = NumberRange.new(1.75, 2),
		starttrans = NumberRange.new(0, 0),
		endtrans = NumberRange.new(1, 1),
		startsize = NumberRange.new(.75, 1),
		endsize = NumberRange.new(.3, .5),
		startposx = NumberRange.new(-.5, .5),
		startposy = NumberRange.new(-.5, .5),
		startrot = NumberRange.new(-360, 360),
	},
	anim = {
		dur = .04,
		loop = false,
		tweentrans = true,
	},
	soundid = {
		volume = .5
	},
	img = {
		plain = false,
		height = 1,
		aspectratio = 1,
		color = Color3.fromRGB(255, 255, 255),
		trans = 0
	},
	stroke = {
		trans = nil,
		thickness = .2,
		color = Color3.new(0, 0, 0)
	},
	mark = {
		color = config.COLOR_SHORTCUTS.yellow,
		trans = .5
	},
	fog = {
		color = Color3.fromRGB(126, 126, 126)
	}
} :: types.attributes

config.emptyAttributes = {
	slide = {},
	transparent = {},
	bounce = {},
	wiggle = {},
	shake = {},
	rainbow = {},
	emitimg = {},
	anim = {},
	soundid = {},
	img = {},
	stroke = {},
	mark = {},
	fog = {}
} :: types.attributes

-- shiny effect
config.SHINY_IMG_ID = 115010102642915
config.SHINY_EMIT_ATTRS = {
	color = Color3.fromRGB(255, 255, 255),
	aspectratio = .66,
	rate = .1,
	chance = 50,
	lifetime = NumberRange.new(2, 2.75),
	velx = NumberRange.new(0, 0),
	vely = NumberRange.new(0, 0),
	rotvel = NumberRange.new(0, 0),
	accelx = NumberRange.new(0, 0),
	accely = NumberRange.new(-.25, -.15),
	starttrans = NumberRange.new(0, 0),
	endtrans = NumberRange.new(1, 1),
	startsize = NumberRange.new(1.5, 2),
	endsize = NumberRange.new(.3, .5),
	startposx = NumberRange.new(-.5, .5),
	startposy = NumberRange.new(-.5, .5),
	startrot = NumberRange.new(0, 0),
} :: typeof(config.DEFAULT_ATTRIBUTES.emitimg)

-- fog effect
config.FOG_IMG_ID = 122434532
config.FOG_EMIT_ATTRS = {
	color = Color3.fromRGB(130, 130, 130),
	aspectratio = 1,
	rate = 2,
	chance = 80,
	lifetime = NumberRange.new(5, 7),
	velx = NumberRange.new(0, 0),
	vely = NumberRange.new(0, 0),
	rotvel = NumberRange.new(-40, 40),
	accelx = NumberRange.new(-.15, .15),
	accely = NumberRange.new(-.15, .15),
	starttrans = NumberRange.new(.9, .95),
	endtrans = NumberRange.new(1, 1),
	startsize = NumberRange.new(1, 2),
	endsize = NumberRange.new(4, 5),
	startposx = NumberRange.new(-.5, .5),
	startposy = NumberRange.new(-.5, .5),
	startrot = NumberRange.new(-360, 360),
} :: typeof(config.DEFAULT_ATTRIBUTES.emitimg)

return config