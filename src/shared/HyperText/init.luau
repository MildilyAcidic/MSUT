--!strict

--[[

	HyperText v2.0.6

	Made by @lopjoss

]]

--[[ Info:

	HyperText is an advanced rich text module which lets you style and manipulate
	text with markup tags and render it inside any GuiObject. It supports paired
	tags, like <font=...></font>, that wrap around the text of which it should
	apply its markup to, with some having the possibility for optional attributes
	added directly in the opening tag, like <anim=wiggle dur=5 loop=false>. Some
	values, like animations, can have their own unique attributes too, which
	you'd also just put in the opening tag. If you want to just change an
	attribute of a markup tag, you don't necessarily have to assign a value to
	the tag, like <anim loop=true>.

	Self-enclosed tags, like <br=2>, can be used on their own. This module
	does not support using < outside of tags.

	Example:
		Today I crashed into a <fog=true color=0,235,0>garbage truck</fog>.
		<br=1><wait=2><anim=wiggle freq=2 loop=true>The driver was not happy.</anim>
		
]]

--[[ Available markup tags, values and attributes:

	<anim=slide></anim>
		
		The animation of the rendered text.
		Set the value to / to remove this.
		
		attributes:
			dur 			: number 			the duration of the animation
			loop 			: boolean 			whether the animation should loop or not
			tweentrans		: boolean 			whether it should tween the text's transparency from fully transparent to the value of the trans markup
		
		all animations and their attributes:
			slide:
				dir 		: "up" | "down" 	the direction in which the animated text moves 
				offset 		: number 			a fraction of text's size to offset the x and y starting position
				rotation 	: number 			the rotation in deg when starting
			transparent:
				strength 	: number 			the starting transparency
			bounce:
				dir 		: "up" | "down" 	the direction in which the animated text moves 
				offset 		: number 			a fraction of text's size to offset the y starting position
			wiggle:
				freq 		: number			the sine wave frequency in Hz (higher value = wiggling faster)
				offset 		: number			a fraction of one sine wave oscillation offsetted per character
				amp 		: number 			a fraction of text's size which acts as the amplitude of the sine wave
		
	<color=255,255,255></color> | <color=red></color>
	
		The color of the rendered text in r,g,b format. 
		Can make use of shortcuts, like red, green, blue, etc. instead of this
		format. Check the config module to see all those shortcuts.

	<font=rbxasset://fonts/families/Arial.json></font> | <font=12187377099></font>
	
		The font used for the rendered text.
		This might add a slight delay when rendering due to it having to download a new font, so pre-rendering 
		the text before that is recommended (that is if you're sure the font hasn't been dowloaded already).
		Fonts are found in the Creator Store or here: https://create.roblox.com/docs/reference/engine/datatypes/Font

	<italic=true></italic>
	
		Indicates whether the rendered text should be italic or not.
		
	<weight=ExtraBold></weight> | <weight=extrabold></weight>
	
		The font weight of the rendered text.
		All available font weights found at:
		https://create.roblox.com/docs/reference/engine/enums/FontWeight

	<trans=.25></trans>
	
		The transparency of the rendered text.
		
	<size=16></size>
	
		The size of the rendered text in offset. Clamped between 0 and 100.
		Unaffected by any UIScale applied to the container.
	
	<shake=true></shake>
	
		Shakes the rendered text.

		attributes:
			maxoffset 		: number			the max possible fraction of text's size to offset the x and y starting position
			dur 			: number 			the duration of the shake
			loop 			: boolean 			whether the shake should loop or not,
			
	<rainbow=true></rainbow>
	
		Cycles the rendered text's color through the colors of a rainbow, with
		each character slightly color-shifted.

		attributes:
			freq			: number			the hue cycle frequency in Hz (higher value = changing color faster)
			offset			: number			a fraction of one hue cycle offsetted per character

	<emitimg=1234567890></emitimg>
	
		Emits an image with the given ID as a particle effect.
		
		attributes:
			color 			: Color3 (r,g,b)			the color of the image
			aspectratio		: number					the width to height ratio of the image
			rate 			: number					the emit requests per second per character
			chance 			: number					the chance in percentage of spawning an image per request
			lifetime 		: NumberRange (min,max) 	a range indicating the lifetime of the image in seconds
			velx			: NumberRange (min,max)		a range indicating the horizontal velocity measured in a fraction of the character's width per second
			vely			: NumberRange (min,max)		a range indicating the vertical velocity measured in a fraction of the text's size per second
			rotvel			: NumberRange (min,max)		a range indicating the rotatory velocity measured in degrees per second
			accelx			: NumberRange (min,max)		a range indicating the horizontal acceleration measured in a fraction of the character's width per second
			accely			: NumberRange (min,max)		a range indicating the vertical acceleration measured in a fraction of the text's size per second
			starttrans		: NumberRange (min,max)		a range indicating the transparency of the image at the beginning of its lifetime
			endtrans		: NumberRange (min,max)		a range indicating the transparency of the image at the end of its lifetime
			startsize 		: NumberRange (min,max)		a range (fractional of the text's size) indicating the height of the image at the beginning of its lifetime
			endsize			: NumberRange (min,max)		a range (fractional of the text's size) indicating the height of the image at the end of its lifetime
			startposx		: NumberRange (min,max)		a range (fractional of the character's width) indicating the horizontal offset of the image at the beginning of its lifetime
			startposy		: NumberRange (min,max)		a range (fractional of the text's size) indicating the vertical offset of the image at the beginning of its lifetime
			startrot 		: NumberRange (min,max)		a range indicating the rotation of the image at the beginning of its lifetime
	
	<stroke=true></stroke>
	
		Gives the rendered text a stroke.
		
		attributes:
			trans			: number? (n | "/")		the transparency of the stroke. When its nil (by setting the value to "/") the stroke will inherit the text's transparency. 
			thickness 		: number				a fraction of the text's size which acts as the thickness of the stroke
			color 			: Color3 (r,g,b)		the color of the stroke
	
	<underline=true></underline>
	
		Underlines the rendered text.

	<strike=true></strike>
	
		Applies a strikethrough (horizontal line through the text) to the rendered text.
	
	<mark=true></mark>
	
		Highlights the rendered text.
		
		attributes:
			color 			: Color3 (r,g,b)	the color of the highlight
			trans			: number			the transparency of the highlight
	
	<interval=.05></interval>
	
		The interval in seconds between each printed character of the rendered text.
		
	<soundid=1234567890></soundid> | <soundid=rbxassetid://1234567890></soundid>
	
		The asset ID for the typewriter sound that will be played when actively
		rendering text.
		Set the value to / to remove this markup.
		
		attributes:
			volume 			: number			the volume of the sound
	
	<img=1234567890>
	
		Adds an image with the given ID.

		attributes:
			plain			: boolean			prevents the current animation and active effects to be applied to the image
			height			: number			a fraction of the text's size indicating the height of the image
			aspectratio		: number			the width to height ratio of the image
			trans			: number			the transparency of the image
			color 			: Color3 (r,g,b)	the color of the image
	
	<shiny=true></shiny>
	
		Adds shiny sparks to the rendered text.
		
	<fog=true></fog>
	
		Adds a fog effect to the rendered text.
		
		attributes:
			color 			: Color3 (r,g,b)	the color of the fog
	
	<wait=5>
	
		Pauses rendering for the specified time in seconds.
		Call :ResumeRender() to stop this wait and resume rendering.

	<br=2>
	
		Adds a line break for the specified amount.
	
]]

--[[ Available markups without tags:

	Listed here are some markups which don't use any tags and can only be
	applied by changing the default markup of an object.

	zindex : number
	
		The Z index given to any rendered content.
		
	xalign : Enum.HorizontalAlignment
	
		The horizontal alignment of the rendered text.

	yalign : Enum.VerticalAlignment
	
		The vertical alignment of the rendered text.
		
	scaleDimension : "X" | "Y"
	
		The container's dimension used as a reference to proportionally scale
		the rendered text.
		
	sizeConstraint : Enum.SizeConstraint
	
		The size constraint of the rendered text.

]]

--[[ API:
	
	.new(container, defaultMarkup, defaultAttributes) : classType

		Creates and returns a new HyperText object.

		container: GuiObject
		The GuiObject that will contain any rendered text. When it gets
		destroyed, the object will get destroyed too.

		defaultMarkup: markup?
		A dict which overwrites the object's default markup.
		Obtained from calling .newMarkup().
		
		defaultAttributes: attributes?
		A dict which overwrites the object's default attributes.
		Obtained from calling .newAttributes().
	
	.newMarkup() : markup
	
		Returns an empty dict typed as markup.

	.newAttributes() : attributes
	
		Returns an empty dict typed as attributes.
	
	:UpdateDefaultMarkup(defaultMarkup, defaultAttributes)
	
		Overwrites the object's default markup and / or attributes with the
		given dicts.
	
		defaultMarkup: markup?
		The dict to overwrite the object's default markup.
		Obtained from calling .newMarkup().
		
		defaultAttributes: attributes?
		The dict to overwrite the object's default attributes.
		Obtained from calling .newAttributes().
	
	:Render(text, yield, wrapped, preRender)

	    Renders the given text inside the object's container and applies the
	    object's default markup & attributes to it. Stops any previous render
	    and clears its text.

		text: string
		The text (including its markup) that is going to be rendered.
		
		yield: boolean?
	    Indicates whether the render should yield the calling thread.
		
		wrapped: boolean?
		Indicates whether the rendered text should wrap inside the object's
		container. Defaults to true.
	    
		preRender: boolean?
	    Indicates whether this call should be performed as a pre-render.
	    Pre-renders are instant (except when having to download any fonts or
	    fetch text bounds) and don't display anything visually.
		Can be used to get the rendered text bounds before the actual render.
		Or to download any new fonts in advance which would prevent possible
		stutters during the actual render.

    :CompleteRender()
	
		Immediately completes rendering. (excluding pre-renders)
		
	:PauseRender()
	
		Pauses rendering. (excluding pre-renders)
		
	:ResumeRender()
	
		Resumes paused rendering.
		
	:GetRenderedTextBounds()
	
		Returns the text bounds of the currently rendered text.

	:Clear()
	
		Stops any rendering and clears any rendered text.
		
	:Destroy()
	
		Stops any rendering, clears any rendered text, and destroys the object.
		
	.onRenderEnded
	
		A BindableEvent that will fire when a render has completed or been
		cleared. (excluding pre-renders)
		When fired it passes 1 boolean argument which indicates whether this
		stop originates from :CompleteRender()
		
	.empty
	
		A boolean that indicates whether the object's container holds no visibly
		rendered text, so excluding pre-rendered text.
		
	.rendering
	
		A boolean that indicates whether the object has any active render going,
		despite it possibly being paused.

]]

--[[ TODO:
	- group neighboring whitespaces into a single word
	- make self enclosed tags not print on utilization
	
	- gradient markup
	- shadow markup
	- grow anim
	- float markup
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local util = require(script.Internal.Util)
local types = require(script.Internal.Types)
local config = require(script.Internal.Config)
local scheduler = require(script.Internal.Scheduler)

local updater : {[string] : (dt : number) -> ()} = {}

type formatAttribute = (value : string) -> types.attributes

type markup = {
	format : (value : string, self : classType) -> types.markup,
	attributes : {
		[string] : formatAttribute
	}?
}

type selfClosingMarkup = {
	utilize : (value : any, self : classType, attributes : types.attributes) -> (),
	convert : (value : string, self : classType) -> any,
	attributes : {
		[string] : formatAttribute
	}?
}

local HyperText = {}
HyperText.__index = HyperText

local selfClosingMarkups : {[string] : selfClosingMarkup} = {}
selfClosingMarkups.wait = {
	utilize = function(value : number, self : classType)
		if not self._preRender and not self._ignoreIntervals then
			
			local continued
			
			self:PauseRender()
			
			task.delay(value, function()
				if not continued then
					self:ResumeRender()
				end
			end)
			
			coroutine.yield()
			
			continued = true
		end
	end,
	convert = util.stringToNumber
}
selfClosingMarkups.br = {
	utilize = function(value : number, self : classType)
		for i = 1, value do
			self:_CreateNewRow(self._renderMarkup :: types.markup)
		end
	end,
	convert = util.stringToNumber
}
selfClosingMarkups.img = {
	utilize = function(value : number, self : classType, attributes : types.attributes)
		if 
			self._renderMarkup
			and self._currentRow
			and self._renderAttributes
		then
			local height = self:_GetProportionalSize() * attributes.img.height
			local width = height * attributes.img.aspectratio
			
			if self._wrapped and util.getWidthOfChildren(self._currentRow) + width > self._container.AbsoluteSize.X then
				self:_CreateNewRow(self._renderMarkup)
			end
			
			self:_SetRowHeight(height, self._currentRow, self._renderMarkup)
			
			local sizeConstraint = self._renderMarkup.sizeConstraint
			local currentRow = self._currentRow
			
			local container = Instance.new("Frame", self._currentRow)
			container.SizeConstraint = sizeConstraint
			container.Size = UDim2.fromScale(
				(
					sizeConstraint == Enum.SizeConstraint.RelativeXY
						or sizeConstraint == Enum.SizeConstraint.RelativeXX
				) and width / currentRow.AbsoluteSize.X or width / currentRow.AbsoluteSize.Y,
				(
					sizeConstraint == Enum.SizeConstraint.RelativeXY
						or sizeConstraint == Enum.SizeConstraint.RelativeYY
				) and height / currentRow.AbsoluteSize.Y or height / currentRow.AbsoluteSize.X
			)
			container.Name = "Image_" .. value
			container.BackgroundTransparency = 1
			container.ZIndex = self._renderMarkup.zindex

			local animContainer = Instance.new("Frame", container)
			animContainer.Name = "AnimationContainer"
			animContainer.Size = UDim2.fromScale(1, 1)
			animContainer.BackgroundTransparency = 1
			animContainer.ZIndex = self._renderMarkup.zindex

			local image = Instance.new("ImageLabel", container)
			image.Size = UDim2.fromScale(1, 1)
			image.SizeConstraint = sizeConstraint
			image.BackgroundTransparency = 1
			image.Image = "rbxassetid://" .. value
			image.ImageTransparency = attributes.img.trans
			image.ImageColor3 = attributes.img.color
			image.ZIndex = self._renderMarkup.zindex
			
			self:_OverflowCheck()
			
			if not attributes.img.plain then
				self:_Animate(
					animContainer,
					image,
					self._renderMarkup,
					self._renderAttributes
				)

				self:_ApplyEffect(
					image,
					image,
					self._renderMarkup,
					self._renderAttributes
				)
			end
		end
	end,
	convert = util.stringToNumber,
	attributes = {
		plain = function(value : string)
			local format = HyperText.newAttributes()
			format.img.plain = util.stringToBoolean(value)

			return format
		end,
		height = function(value : string)
			local format = HyperText.newAttributes()
			format.img.height = util.stringToNumber(value)

			return format
		end,
		aspectratio = function(value : string)
			local format = HyperText.newAttributes()
			format.img.aspectratio = util.stringToNumber(value)

			return format
		end,
		trans = function(value : string)
			local format = HyperText.newAttributes()
			format.img.trans = util.stringToNumber(value)

			return format
		end,
		color = function(value : string)
			local format = HyperText.newAttributes()
			format.img.color = config.COLOR_SHORTCUTS[value] or util.stringToColor3(value)

			return format
		end,
	}
}

local markups : {[string] : markup} = {}
markups.size = {
	format = function(value : string)
		return {size = math.clamp(util.stringToNumber(value), 0, 100)} :: types.markup
	end,
}
markups.shiny = {
	format = function(value : string)
		return {shiny = util.stringToBoolean(value)} :: types.markup
	end,
}
markups.fog = {
	format = function(value : string)
		return {fog = util.stringToBoolean(value)} :: types.markup
	end,
	attributes = {
		color = function(value : string)
			local format = HyperText.newAttributes()
			format.fog.color = config.COLOR_SHORTCUTS[value] or util.stringToColor3(value)
			
			return format
		end,
	}
}
markups.mark = {
	format = function(value : string)
		return {mark = util.stringToBoolean(value)} :: types.markup
	end,
	attributes = {
		color = function(value : string)
			local format = HyperText.newAttributes()
			format.mark.color = config.COLOR_SHORTCUTS[value] or util.stringToColor3(value)
			
			return format
		end,
		trans = function(value : string)
			local format = HyperText.newAttributes()
			format.mark.trans = util.stringToNumber(value)
			
			return format
		end,
	}
}
markups.underline = {
	format = function(value : string)
		return {underline = util.stringToBoolean(value)} ::  types.markup
	end,
}
markups.strike = {
	format = function(value : string)
		return {strike = util.stringToBoolean(value)} :: types.markup
	end,
}
markups.stroke = {
	format = function(value : string)
		return {stroke = util.stringToBoolean(value)} :: types.markup
	end,
	attributes = {
		trans = function(value : string)
			local format = HyperText.newAttributes()
			format.stroke.trans = value ~= "/" and util.stringToNumber(value) or nil
			
			return format
		end,
		thickness = function(value : string)
			local format = HyperText.newAttributes()
			format.stroke.thickness = util.stringToNumber(value)
			
			return format
		end,
		color = function(value : string)
			local format = HyperText.newAttributes()
			format.stroke.color = config.COLOR_SHORTCUTS[value] or util.stringToColor3(value)
			
			return format
		end,
	}
}
markups.italic = {
	format = function(value : string)
		return {italic =  util.stringToBoolean(value)} :: types.markup
	end,
}
markups.interval = {
	format = function(value : string)
		return {interval = util.stringToNumber(value)} :: types.markup
	end,
}
markups.soundid = {
	format = function(value : string)
		local new : string? = value
		
		if value ~= "/" then
			local success, errmsg = pcall(function()
				return util.stringToNumber(value)
			end)
			if not success then
				new = value
			else
				new = "rbxassetid://" .. tostring(value)
			end
		else
			new = nil
		end
		
		return {soundid = new} :: types.markup
	end,
	attributes = {
		volume = function(value : string)
			local format = HyperText.newAttributes()
			format.soundid.volume = util.stringToNumber(value)

			return format
		end,
	}
}
markups.trans = {
	format = function(value : string)
		return {trans = util.stringToNumber(value)} :: types.markup
	end,
}
markups.font = {
	format = function(value : string, self : classType)
		--local value = util.fetchTextBounds(self._id, ".", config.DEFAULT_MARKUP) and value or nil
		local success, errmsg = pcall(function()
			return util.stringToNumber(value)
		end)
		if success then
			value = "rbxassetid://" .. tostring(value)
		end

		return {font = value} :: types.markup
	end,
}
markups.weight = {
	format = function(value : string)
		return {weight = util.stringToFontWeight(value)} :: types.markup
	end,
}
markups.color = {
	format = function(value : string)
		local value = config.COLOR_SHORTCUTS[value] or util.stringToColor3(value)
		
		return {color = value} :: types.markup
	end,
}
markups.anim = {
	format = function(value : string)
		if value ~= "/" then
			for k in pairs(types.literal.animations :: any) do
				if k == string.lower(value) then
					return {anim = k} :: types.markup
				end
			end

			error(value .. " is not a valid animation", 0)
		else
			return {anim = nil} :: types.markup
		end
	end,
	attributes = {
		dur = function(value : string)
			local format = HyperText.newAttributes()
			format.anim.dur = util.stringToNumber(value)
			
			return format 
		end,
		loop = function(value : string)
			local format = HyperText.newAttributes()
			format.anim.loop = util.stringToBoolean(value)
			
			return format
		end,
		tweentrans = function(value : string)
			local format = HyperText.newAttributes()
			format.anim.tweentrans = util.stringToBoolean(value)

			return format
		end,
	}
}
markups.shake = {
	format = function(value : string)
		return {shake = util.stringToBoolean(value)} :: types.markup
	end,
	attributes = {
		maxoffset = function(value : string) 
			local format = HyperText.newAttributes()
			format.shake.maxoffset = util.stringToNumber(value)

			return format
		end,
		dur = function(value : string)
			local format = HyperText.newAttributes()
			format.shake.dur = util.stringToNumber(value)
			
			return format
		end,
		loop = function(value : string)
			local format = HyperText.newAttributes()
			format.shake.loop = util.stringToBoolean(value)
			
			return format
		end,
	}
}
markups.rainbow = {
	format = function(value : string)
		return {rainbow = util.stringToBoolean(value)} :: types.markup
	end,
	attributes = {
		freq = function(value : string) 
			local format = HyperText.newAttributes()
			format.rainbow.freq = util.stringToNumber(value)

			return format
		end,
		offset = function(value : string) 
			local format = HyperText.newAttributes()
			format.rainbow.offset = util.stringToNumber(value)

			return format
		end,
	}
}
markups.emitimg = {
	format = function(value : string)
		return {emitimg = util.stringToNumber(value)} :: types.markup
	end,
	attributes = {
		color = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.color = config.COLOR_SHORTCUTS[value] or util.stringToColor3(value)

			return format
		end,
		aspectratio = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.aspectratio = util.stringToNumber(value)

			return format
		end,
		rate = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.rate = util.stringToNumber(value)

			return format
		end,
		chance = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.chance = util.stringToNumber(value)

			return format
		end,
		
		lifetime = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.lifetime = util.stringToNumberRange(value)

			return format
		end,
		velx = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.velx = util.stringToNumberRange(value)

			return format
		end,
		vely = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.vely = util.stringToNumberRange(value)

			return format
		end,
		rotvel = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.rotvel = util.stringToNumberRange(value)

			return format
		end,
		accelx = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.accelx = util.stringToNumberRange(value)

			return format
		end,
		accely = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.accely = util.stringToNumberRange(value)

			return format
		end,
		starttrans = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.starttrans = util.stringToNumberRange(value)

			return format
		end,
		endtrans = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.endtrans = util.stringToNumberRange(value)

			return format
		end,
		startsize = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.startsize = util.stringToNumberRange(value)

			return format
		end,
		endsize = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.endsize = util.stringToNumberRange(value)

			return format
		end,
		startposx = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.startposx = util.stringToNumberRange(value)
			
			return format
		end,
		startposy = function(value : string)
			local format = HyperText.newAttributes()
			format.emitimg.startposy = util.stringToNumberRange(value)

			return format
		end,
		startrot = function(value : string) 
			local format = HyperText.newAttributes()
			format.emitimg.startrot = util.stringToNumberRange(value)

			return format
		end,
	}
}

local VALUE_ATTRS_FORMATTING : {[string] : {[string] : formatAttribute}} = {
	-- ANIMATIONS
	slide = {
		dir = function(value : string)
			for k in pairs(types.literal.dir :: any) do
				if k == string.lower(value) then
					return {dir = k} :: types.attributes
				end
			end
			
			error(value .. " is not a valid direction. See literal type dir in types.", 0)
		end,
		offset = function(value : string) 
			local format = HyperText.newAttributes()
			format.slide.offset = util.stringToNumber(value)

			return format
		end,
		rotation = function(value : string) 
			local format = HyperText.newAttributes()
			format.slide.rotation = util.stringToNumber(value)

			return format
		end,
	},
	transparent = {
		strength = function(value : string) 
			local format = HyperText.newAttributes()
			format.transparent.strength = util.stringToNumber(value)

			return format
		end,
	},
	bounce = {
		dir = function(value : string)
			for k in pairs(types.literal.dir :: any) do
				if k == string.lower(value) then
					return {dir = k} :: types.attributes
				end
			end

			error(value .. " is not a valid direction. See literal type dir in types.", 0)
		end,
		offset = function(value : string) 
			local format = HyperText.newAttributes()
			format.bounce.offset = util.stringToNumber(value)

			return format
		end,
	},
	wiggle = {
		freq = function(value : string) 
			local format = HyperText.newAttributes()
			format.wiggle.freq = util.stringToNumber(value)

			return format
		end,
		offset = function(value : string) 
			local format = HyperText.newAttributes()
			format.wiggle.offset = util.stringToNumber(value)

			return format
		end,
		amp = function(value : string) 
			local format = HyperText.newAttributes()
			format.wiggle.amp = util.stringToNumber(value)

			return format
		end,
	},
}

export type classType = typeof(
	setmetatable(
		{} :: {
			_container : GuiObject,
			_markup : types.markup,
			_attributes : types.attributes,
			_scheduler : scheduler.classType,
			_id : number,
			empty : boolean,
			rendering : boolean,
			onRenderEnded : BindableEvent,

			_text : string?,
			_layout : UIListLayout?,
			_wrapped : boolean?,
			_renderMarkup : types.markup?,
			_renderAttributes : types.attributes?,
			_renderTraceback : string?,
			_preRender : boolean?,
			_pausedRender : boolean?,
			_contentFolder : Folder?,
			_containerDefaultAbsoluteSize : Vector2?,
			_markupHistory : {[number] : {
				type : string,
				markup : types.markup?,
				attributes : types.attributes
			}}?,
			_executionThread : thread?,
			_ignoreIntervals : boolean?,
			_currentRow : Frame?,
			_cachedTypewriterSound : Sound?,
			_currentWord : {[number] : {
				str : string,
				index : number,
				markup : types.markup,
				attributes : types.attributes
			}}?,
			_markupIndices : {[string] : number}?,
			_verticalOverflowWarn : boolean?,
			_horizontalOverflowWarn : boolean?,
			_nextTypewriterSfxTime : number?,
			_loadingTypewriterSfx : boolean?,
		},
		HyperText
	)
)

--[[
	Creates and returns a new HyperText object.

	<strong>container</strong>: GuiObject
	The GuiObject that will contain any rendered text. When it gets destroyed, the object will get destroyed too.

	<strong>defaultMarkup</strong>: markup?
	A dict which overwrites the object's default markup.
	Obtained from calling <code>.newMarkup()</code>.
	
	<strong>defaultAttributes</strong>: attributes?
	A dict which overwrites the object's default attributes.
	Obtained from calling <code>.newAttributes()</code>.
]]
HyperText.new = function(
	container : GuiObject,
	defaultMarkup : types.markup?,
	defaultAttributes : types.attributes?
) : classType
	local self = setmetatable(
		{
			_container = container,
			_markup = table.clone(config.DEFAULT_MARKUP),
			_attributes = util.deepCopy(config.DEFAULT_ATTRIBUTES),
			_scheduler = scheduler.new(),
			_id = os.clock(),
			
			empty = true,
			rendering = false,
			onRenderEnded = Instance.new("BindableEvent"),
		},
		HyperText
	) :: classType
	
	self:UpdateDefaultMarkup(defaultMarkup, defaultAttributes)
	
	container.Destroying:Once(function()
		self:Destroy()
	end)

	return self
end

--[[
	Returns an empty dict typed as markup.
]]
HyperText.newMarkup = function()
	return {} :: types.markup
end

--[[
	Returns an empty dict typed as attributes.
]]
HyperText.newAttributes = function()
	return util.deepCopy(config.emptyAttributes)
end

--[[
	Overwrites the object's default markup and / or attributes with the given dicts.
	
	<strong>defaultMarkup</strong>: markup?
	The dict to overwrite the object's default markup.
	Obtained from calling <code>.newMarkup()</code>.
	
	<strong>defaultAttributes</strong>: attributes?
	The dict to overwrite the object's default attributes.
	Obtained from calling <code>.newAttributes()</code>.
]]
function HyperText.UpdateDefaultMarkup(
	self : classType,
	defaultMarkup : types.markup?,
	defaultAttributes : types.attributes?
)
	if defaultMarkup then
		util.updateMarkup(self._markup, defaultMarkup)
	end
	if defaultAttributes then
		util.updateAttributes(self._attributes, defaultAttributes)
	end
end

--[[
    Renders the given text inside the object's container and applies the object's default markup & attributes to it. Stops any previous render and clears its text.

	<strong>text</strong>: string
	The text (including its markup) that is going to be rendered.
	
	<strong>yield</strong>: boolean?
    Indicates whether the render should yield the calling thread.
	
	<strong>wrapped</strong>: boolean?
	Indicates whether the rendered text should wrap inside the object's container. Defaults to true.
    
	<strong>preRender</strong>: boolean?
    Indicates whether this call should be performed as a pre-render.
    Pre-renders are instant (except when having to download any fonts or fetch text bounds) and don't display anything visually.
	Can be used to get the rendered text bounds before the actual render. Or to download any new fonts in advance which would prevent possible stutters during the actual render.
]]
function HyperText.Render(
	self : classType,
	text : string,
	yield : boolean?,
	wrapped : boolean?,
	preRender : boolean?
)
	local source, line = debug.info(2, "sl")
	local renderTraceback = string.format("Resulting from Render call at:\n%s Line %s", source, line)
	self._renderTraceback = renderTraceback

	if self._container.AbsoluteSize.Magnitude > 0 then
		if 
			self._container.AbsoluteSize.X ~= 0
			or self._markup.sizeConstraint == Enum.SizeConstraint.RelativeYY
		then
			if 
				self._container.AbsoluteSize.Y ~= 0
				or self._markup.sizeConstraint == Enum.SizeConstraint.RelativeXX
			then
				self:Clear()

				self.empty = preRender or false
				self.rendering = true

				self._verticalOverflowWarn = false
				self._horizontalOverflowWarn = false
				self._text = text
				local renderMarkup = table.clone(self._markup)
				self._renderMarkup = renderMarkup
				local renderAttributes = util.deepCopy(self._attributes)
				self._renderAttributes = renderAttributes
				self._preRender = preRender or false
				self._wrapped = wrapped or wrapped == nil and true
				self._pausedRender = false
				self._markupIndices = {}
				self._markupHistory = {}
				self._currentWord = {}
				self._ignoreIntervals = false
				self._scheduler:Empty()

				local contentFolder = Instance.new("Folder", self._container)
				contentFolder.Name = "HyperTextContent"
				self._contentFolder = contentFolder

				self._containerDefaultAbsoluteSize = self._container.AbsoluteSize

				local layout = Instance.new("UIListLayout", self._contentFolder)
				layout.VerticalAlignment = renderMarkup.yalign
				self._layout = layout

				self:_CreateNewRow(renderMarkup)
				self:_Parse()

				local executionThread = coroutine.create(function()
					self._scheduler:Iterate()

					self.rendering = false

					if not self._preRender then
						self.onRenderEnded:Fire(self._ignoreIntervals)
					end
				end)
				self._executionThread = executionThread

				coroutine.resume(executionThread)

				if yield then
					self:_YieldWhile(function()
						return self.rendering
					end)
				end
			else
				warn("Cannot render: object's container has an absolute height of 0\n" .. renderTraceback)
			end
		else
			warn("Cannot render: object's container has an absolute width of 0\n" .. renderTraceback)
		end
	else
		warn("Cannot render: object's container has an absolute size of 0, 0\n" .. renderTraceback)
	end
end

--[[
	Immediately completes rendering. (excluding pre-renders)
]]
function HyperText.CompleteRender(self : classType)
	if 
		not self._preRender
		and self.rendering
	then
		self:ResumeRender()

		self._ignoreIntervals = true
	end
end

--[[
	Pauses rendering. (excluding pre-renders)
]]
function HyperText.PauseRender(self : classType)
	if 
		not self._pausedRender
		and not self._preRender 
	then
		self._pausedRender = true
	end
end

--[[
	Resumes paused rendering.
]]
function HyperText.ResumeRender(self : classType)
	if 
		self._pausedRender
		and self._executionThread
		and coroutine.status(self._executionThread) == "suspended"
		and not self._preRender
	then
		self._pausedRender = false

		coroutine.resume(self._executionThread)
	end
end

--[[
	Returns the text bounds of the currently rendered text
]]
function HyperText.GetRenderedTextBounds(self : classType) : Vector2
	local maxWidth = 0
	if self._contentFolder then
		for _, row in ipairs(self._contentFolder:GetChildren()) do
			if row:IsA("Frame") then
				local layout = row:FindFirstChildWhichIsA("UIListLayout") :: UIListLayout

				maxWidth = math.max(maxWidth, layout.AbsoluteContentSize.X)
			end
		end
	end
	
	return Vector2.new(
		maxWidth,
		self._layout and self._layout.AbsoluteContentSize.Y or 0
	)
end

--[[
    Stops any rendering and clears any rendered text.
]]
function HyperText.Clear(self : classType)
	if 
		(not self.empty or self._preRender)
		and self._contentFolder
		and self._executionThread
	then
		task.cancel(self._executionThread)
		
		self._contentFolder:Destroy()
		
		self.empty = true
	end
end

--[[
	Stops any rendering, clears any rendered text, and destroys the object.
]]
function HyperText.Destroy(self : classType)
	self:Clear()
	
	util.removeTextBoundsCache(self._id)
end

function HyperText._GetProportionalSize(self : classType, size : number?) : number
	if
		self._renderMarkup
		and self._containerDefaultAbsoluteSize
	then
		return (size or self._renderMarkup.size) * 
			(
				self._renderMarkup.scaleDimension == "X"
				and (self._container.AbsoluteSize.X / self._containerDefaultAbsoluteSize.X)
				or (self._container.AbsoluteSize.Y / self._containerDefaultAbsoluteSize.Y)
			)
	else
		return 0
	end
end

function HyperText._CreateNewRow(self : classType, markup : types.markup)
	if self._container then
		local row = Instance.new("Frame", self._contentFolder)
		row.SizeConstraint = markup.sizeConstraint
		row.Name = "Row"
		row.Size = UDim2.fromScale(1, 0)
		row.BackgroundTransparency = 1
		row.ZIndex = markup.zindex
		
		self._currentRow = row

		local layout = Instance.new("UIListLayout", row)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.HorizontalAlignment = markup.xalign
	end
end

function HyperText._OverflowCheck(self : classType)
	if 		
		self._currentRow
		and self._text
		and self._contentFolder
		and self._renderTraceback
		and self._layout
	then
		if not self._preRender then
			if 
				not self._horizontalOverflowWarn
				and self._container.AutomaticSize ~= Enum.AutomaticSize.X
			then
				for _, row in ipairs(self._contentFolder:GetChildren()) do
					if row:IsA("Frame") then
						if util.getWidthOfChildren(row) > self._container.AbsoluteSize.X then
							self._horizontalOverflowWarn = true

							warn(
								"Text \"" .. string.sub(self._text, 1, config.DEBUG_OVERFLOW_MAX_TEXT_LENGTH)
									.. (#self._text > config.DEBUG_OVERFLOW_MAX_TEXT_LENGTH and "..." or "")
									.. "\" is horizontally overflowing from its container\n"
									.. self._renderTraceback
							)
						end
					end
				end
			end

			if 
				not self._verticalOverflowWarn
				and self._container.AutomaticSize ~= Enum.AutomaticSize.Y
				and self._layout.AbsoluteContentSize.Y - self._container.AbsoluteSize.Y >= .001
			then
				self._verticalOverflowWarn = true

				warn(
					"Text \"" .. string.sub(self._text, 1, config.DEBUG_OVERFLOW_MAX_TEXT_LENGTH)
						.. (#self._text > config.DEBUG_OVERFLOW_MAX_TEXT_LENGTH and "..." or "")
						.. "\" is vertically overflowing from its container\n"
						.. self._renderTraceback
				)
			end
		end
	end

end

function HyperText._SetRowHeight(
	self : classType,
	height : number,
	row : Frame,
	markup : types.markup
)
	if 
		markup.sizeConstraint == Enum.SizeConstraint.RelativeXY
		or markup.sizeConstraint == Enum.SizeConstraint.RelativeYY
	then
		for _, v in ipairs(row:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Size = UDim2.fromScale(
					markup.sizeConstraint == Enum.SizeConstraint.RelativeYY 
						and v.AbsoluteSize.X / height
						or v.Size.X.Scale,
					v.AbsoluteSize.Y / height
				)
			end
		end
	end

	row.Size = UDim2.fromScale(
		row.Size.X.Scale,
		markup.sizeConstraint == Enum.SizeConstraint.RelativeXX 
			and height / self._container.AbsoluteSize.X
			or height / self._container.AbsoluteSize.Y
	)
end

function HyperText._AppendString(
	self : classType,
	str : string,
	index : number,
	markup : types.markup?,
	attributes : types.attributes?
)
	if self._renderMarkup and self._renderAttributes then
		local markup = markup or table.clone(self._renderMarkup)
		local attributes = attributes or util.deepCopy(self._renderAttributes)
		local currentWord = self._currentWord or {}
		
		table.insert(currentWord, {
			str = str,
			index = index,
			markup = markup,
			attributes = attributes}
		)
		
		self._currentWord = currentWord
	end
end

function HyperText._Print(self : classType, performAsWhitespace : boolean?)
	if 
		self._currentRow
		and self._scheduler.index

		and self._text
		
		and self._currentWord
		and #self._currentWord > 0
	then
		local row = self._currentRow
		local currentWord = self._currentWord
		self._currentWord = nil
		
		-- calculating the width of the word
		-- in case it does not fit, should wrap, and isn't whitespace it starts a new row,
		-- and when occupying more than config.MAX_WORD_WIDTH_FRACTION of the current row
		-- it'll split the word before that
		if self._wrapped then
			local wordWidth = 0
			local split
			local appends = 1
			
			for j = 1, #currentWord do
				local data = currentWord[j]

				if not split then
					for i = 1, string.len(data.str) do
						local size = self:_GetProportionalSize()
						local dashWidth = util.fetchTextBounds(self._id, "-", data.markup, size).X
						local characterWidth = util.fetchTextBounds(self._id, string.sub(data.str, i, i), data.markup, size).X

						local totalWidth = ((row and util.getWidthOfChildren(row)) or 0)
							+ wordWidth
							+ characterWidth
							+ dashWidth

						if totalWidth <= self._container.AbsoluteSize.X then
							wordWidth += characterWidth
						else
							if wordWidth >= self._container.AbsoluteSize.X * config.MAX_WORD_WIDTH_FRACTION then
								self:_CreateNewRow(data.markup)

								local remainder = string.sub(data.str, i, string.len(data.str)):gsub("^%s+", "")
								currentWord[j].str = string.sub(data.str, 1, i - 1) .. "-"

								self._scheduler:Insert(function()
									self:_AppendString(
										remainder,
										data.index + i,
										data.markup,
										data.attributes
									)
								end, self._scheduler.index + 1)

								split = true

								break
							elseif not performAsWhitespace then -- should not print whitespace at the start of a new row
								wordWidth += characterWidth

								self:_CreateNewRow(data.markup)
								row = self._currentRow
							else
								self:_CreateNewRow(data.markup)

								return
							end
						end
					end
				else
					currentWord[j] = nil

					self._scheduler:Insert(function()
						self:_AppendString(data.str, data.index, data.markup, data.attributes)
					end, self._scheduler.index + 1 + appends)
					appends += 1
				end
			end
			if split then
				self._scheduler:Insert(function()
					self:_Print()
				end, self._scheduler.index + 1 + appends)
			end
		end
		
		for i, data in ipairs(currentWord) do
			for i = 1, string.len(data.str) do
				local size = self:_GetProportionalSize()
				local isWhitespace = string.match(data.str, "%s")
				local characterWidth = util.fetchTextBounds(self._id, string.sub(data.str, i, i), data.markup, size).X
				
				if size > row.AbsoluteSize.Y then
					self:_SetRowHeight(size, row, data.markup)
				end
				
				local container = Instance.new("Frame", row)
				container.SizeConstraint = data.markup.sizeConstraint
				container.Size = UDim2.fromScale(
					(
						data.markup.sizeConstraint == Enum.SizeConstraint.RelativeXY
							or data.markup.sizeConstraint == Enum.SizeConstraint.RelativeXX
					) and characterWidth / row.AbsoluteSize.X or characterWidth / row.AbsoluteSize.Y,
					(
						data.markup.sizeConstraint == Enum.SizeConstraint.RelativeXY
							or data.markup.sizeConstraint == Enum.SizeConstraint.RelativeYY
					) and size / row.AbsoluteSize.Y or characterWidth / row.AbsoluteSize.X
				)
				container.Name = string.sub(data.str, i, i)
				container.BackgroundTransparency = 1
				container.ZIndex = data.markup.zindex

				if not self._preRender then
					local animContainer = Instance.new("Frame", container)
					animContainer.Name = "AnimationContainer"
					animContainer.Size = UDim2.fromScale(1, 1)
					animContainer.BackgroundTransparency = 1
					animContainer.ZIndex = data.markup.zindex
					
					local text = string.sub(data.str, i, i)
					if data.markup.strike then
						text = "<s>" .. text .. "</s>"
					end
					if data.markup.underline then
						text = "<u>" .. text .. "</u>"
					end
					
					local char = Instance.new("TextLabel", animContainer)
					char.BorderSizePixel = 0
					char.RichText = true
					char.Size = UDim2.fromScale(1, 1)
					char.BackgroundTransparency = 1
					char.Text = text
					char.TextColor3 = data.markup.color
					char.TextXAlignment = Enum.TextXAlignment.Left
					char.TextTransparency = data.markup.trans
					char.FontFace = typeof(data.markup.font) == "string"
						and Font.new(
							data.markup.font,
							data.markup.weight,
							data.markup.italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal
						)
						or Font.fromId(
							data.markup.font :: number,
							data.markup.weight,
							data.markup.italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal
						)
					char.ZIndex = data.markup.zindex
					
					if data.markup.mark then
						char.BackgroundColor3 = data.attributes.mark.color
						char.BackgroundTransparency = data.attributes.mark.trans
					end
					
					if data.markup.stroke then
						local stroke = Instance.new("UIStroke", char)
						stroke.Thickness = data.attributes.stroke.thickness
						stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
						stroke.Color = data.attributes.stroke.color
						stroke.Transparency = data.attributes.stroke.trans or data.markup.trans

						char:GetPropertyChangedSignal("TextTransparency"):Connect(function()
							if data.attributes.stroke.trans then
								local normal = (char.TextTransparency - data.markup.trans) / (1 - data.markup.trans)

								stroke.Transparency = data.attributes.stroke.trans
									+ (1 - data.attributes.stroke.trans)
									* normal
							else
								stroke.Transparency = char.TextTransparency
							end
						end)
					end
					
					local constraint = Instance.new("UITextSizeConstraint", char)
					constraint.MinTextSize = size
					constraint.MaxTextSize = size

					local defaultSize = data.markup.size
					char:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						local size = self:_GetProportionalSize(defaultSize)
						constraint.MinTextSize = 0

						constraint.MaxTextSize = size
						constraint.MinTextSize = math.clamp(size, 0, 100)
					end)

					self:_Animate(
						animContainer,
						char,
						data.markup,
						data.attributes
					)
					self:_ApplyEffect(
						char,
						char,
						data.markup,
						data.attributes
					)

					local t = os.clock()
					
					if 
						data.markup.soundid
						and not self._loadingTypewriterSfx
						and not self._ignoreIntervals
						and not isWhitespace
						and (
							not self._nextTypewriterSfxTime
								or t >= self._nextTypewriterSfxTime
						)
					then
						if 
							not self._cachedTypewriterSound
							or self._cachedTypewriterSound.SoundId ~= (
								typeof(data.markup.soundid) == "string"
									and data.markup.soundid
									or "rbxassetid://" .. data.markup.soundid
							)
						then
							if self._cachedTypewriterSound then
								self._cachedTypewriterSound:Destroy()
							end

							self._loadingTypewriterSfx = true

							local sound = Instance.new("Sound", script)
							sound.Volume = data.attributes.soundid.volume
							sound.SoundId = typeof(data.markup.soundid) == "string"
								and data.markup.soundid
								or "rbxassetid://" .. data.markup.soundid

							self._cachedTypewriterSound = sound

							local function onLoaded()
								self._loadingTypewriterSfx = false
							end

							if not sound.IsLoaded then
								sound.Loaded:Once(onLoaded)
							else
								onLoaded()
							end
						else
							if self._cachedTypewriterSound.IsPlaying then
								self._cachedTypewriterSound:Stop()
							end

							self._cachedTypewriterSound:Play()

							self._nextTypewriterSfxTime = t + math.max(
								config.MIN_TYPEWRITER_SFX_INTERVAL,
								data.markup.interval
							)
						end
					end
					
					self:_OverflowCheck()
					
					if
						data.markup.interval ~= 0
						and not self._ignoreIntervals
						and data.index + i - 1 ~= #self._text -- should not yield on last character
					then
						self:_Yield(data.markup.interval)
					end

					if self._pausedRender then
						coroutine.yield()
					end
				end
			end			
		end
	end
end

function HyperText._ParseAttrs(
	self : classType,
	i : number,
	valueEndPos : number,
	tagEndPos : number,
	markupValue : string?,
	markup : markup
) : types.attributes
	local formattedAttrs = util.deepCopy(config.emptyAttributes)
	
	if 
		self._text
		and self._renderTraceback
	then
		local t = self._text

		local j = valueEndPos + 1
		while j < tagEndPos do
			local _, attrTypeStartPos = string.find(t, "%S", j)
			local attrTypeEndPos = string.match(t, "[^>=%s]+()", j) :: number -- captures index of first whitespace or > or = 
			local attrValueEndPos = string.match(t, "[^>%s]+()", j) :: number -- captures index of first whitespace or > 

			if attrTypeStartPos and attrTypeStartPos < tagEndPos then
				if attrTypeEndPos < attrValueEndPos - 1 then
					local attrType = string.lower(
						string.sub(
							t,
							attrTypeStartPos,
							attrTypeEndPos - 1
						)
					)
					local attrValue = string.lower(string.sub(t, attrTypeEndPos + 1, attrValueEndPos - 1))

					local availableAttrs : {[string] : formatAttribute} = setmetatable(
						markup.attributes or {},
						{
							__index = markupValue and VALUE_ATTRS_FORMATTING[markupValue] or {}
						}
					) :: any

					if availableAttrs[attrType] then
						local success, formatted = pcall(availableAttrs[attrType], attrValue)

						if success then
							util.updateAttributes(formattedAttrs, formatted)
						else
							warn(
								"Failed to parse attribute \""
									.. string.sub(
										t,
										attrTypeStartPos,
										attrValueEndPos - 1
									)
									.. "\" of tag \"" .. string.sub(t, i, tagEndPos) 
									.. "\": " .. formatted :: any
									.. "\n" .. self._renderTraceback
							)
						end
					else
						warn(
							"Failed to parse attribute \""
								.. string.sub(
									t,
									attrTypeStartPos,
									attrValueEndPos - 1
								)
								.. "\" of tag \"" .. string.sub(t, i, tagEndPos) 
								.. "\": ".. attrType .." is not a valid attribute\n"
								.. self._renderTraceback
						)
					end
				else
					warn(
						"Failed to parse attribute \""
							.. string.sub(
								t,
								attrTypeStartPos,
								attrTypeEndPos - 1
							)
							.. "\" of tag \"" .. string.sub(t, i, tagEndPos) 
							.. "\": no assigned value found\n"
							.. self._renderTraceback
					)
				end

				j = attrValueEndPos + 1
			else
				j = tagEndPos
			end
		end
	end
	
	return formattedAttrs
end

function HyperText._Parse(self : classType)
	if
		self._text
		and self._renderTraceback
	then
		local i = 1
		local t = self._text
		local markupHistory : {[number] : string} = {}
		
		while i <= #t do
			local i_local = i
			local char = string.sub(t, i, i)
			
			if char ~= "<" and not string.match(char, "%s") then
				local word, endPos = string.match(t, "([^<%s]+)()", i) -- captures string from i to a whitespace or < 
				if word then
					self._scheduler:Append(function()					
						self:_AppendString(word, i_local)
					end)
				end
				
				i = endPos or #t
			elseif string.match(char, "%s") then
				self._scheduler:Append(function()
					self:_Print()
				end)
				self._scheduler:Append(function()					
					self:_AppendString(char, i_local)
					self:_Print(true)
				end)

				i += 1
			elseif char == "<" then
				if string.sub(t, i + 1, i + 1) ~= "/" then
					local typeEndPos = string.match(t, "[^=>%s]+()", i) -- captures index of first whitespace or > or =
					local valueEndPos = string.match(t, "[^>%s]+()", i) -- captures index of first whitespace or >
					local _, tagEndPos = string.find(t, ">", i)

					if tagEndPos and valueEndPos and typeEndPos then
						local markupType = string.lower(string.sub(t, i + 1, typeEndPos - 1))
						local markupValue = typeEndPos and typeEndPos < valueEndPos - 1
							and string.lower(string.sub(t, typeEndPos + 1, valueEndPos - 1))
							or nil

						if markups[markupType] or selfClosingMarkups[markupType] then
							if typeEndPos < tagEndPos then
								if markups[markupType] then
									local formattedMarkup : types.markup?
									local markup = markups[markupType]
									if markupValue then
										local success, markup : types.markup | string = pcall(markup.format, markupValue, self)

										if success then
											formattedMarkup = markup :: types.markup
										else
											warn(
												"Failed to parse tag \""
													.. string.sub(t, i, tagEndPos) 
													.. "\": " .. markup :: string
													.. "\n" .. self._renderTraceback
											)
										end
									end

									local formattedAttrs = self:_ParseAttrs(i, valueEndPos, tagEndPos, markupValue, markup)

									table.insert(markupHistory, 1, markupType)

									self._scheduler:Append(function()
										self:_ApplyMarkup(markupType, formattedMarkup, formattedAttrs)
									end)
								elseif selfClosingMarkups[markupType] then
									if markupValue then
										local markup = selfClosingMarkups[markupType]
										
										local formattedAttrs = self:_ParseAttrs(i, valueEndPos, tagEndPos, markupValue, markup)
										local attrs = util.deepCopy(config.DEFAULT_ATTRIBUTES)
										util.updateAttributes(attrs, formattedAttrs)
										
										local success, convertedValue = pcall(
											markup.convert,
											markupValue,
											self
										)

										if success then
											self._scheduler:Append(function()
												self:_Print()
											end)
											self._scheduler:Append(function()
												markup.utilize(convertedValue, self, attrs)
											end)
										else
											warn(
												"Failed to parse tag \""
													.. string.sub(t, i, tagEndPos) 
													.. "\": " .. convertedValue :: string
													.. "\n" .. self._renderTraceback
											)
										end
									else
										warn(
											"Failed to parse tag \"" 
												.. string.sub(t, i, tagEndPos)
												.. "\": no assigned value found\n"
												.. self._renderTraceback
										)
									end
								end
							else
								warn(
									"Failed to parse tag \"" 
										.. string.sub(t, i, tagEndPos)
										.. "\": no assigned value found\n"
										.. self._renderTraceback
								)
							end
						else
							warn(
								"Failed to parse tag \"" 
									.. string.sub(t, i, tagEndPos)
									.. "\": \"".. markupType .."\" is not a valid tag\n"
									.. self._renderTraceback
							)
						end

						i = tagEndPos + 1
					else
						warn(
							"Failed to parse tag \""
								.. string.sub(t, i, #t)
								.. "\": no closing angle bracket found\n"
								.. self._renderTraceback
						)

						i = #t
					end
				else
					local _, tagEndPos = string.find(t, ">", i)

					if tagEndPos then
						local markupType = string.lower(string.sub(t, i + 2, tagEndPos - 1))

						if markups[markupType] then
							for i, v in ipairs(markupHistory) do
								if v == markupType then
									table.remove(markupHistory, i)
									
									self._scheduler:Append(function()
										self:_RemoveMarkup(markupType)
									end)

									break
								elseif i == #markupHistory then
									warn(
										"Failed to parse tag \"</"
											.. markupType .. ">\": no opening tag found\n"
											.. self._renderTraceback
									)
								end
							end
						else
							warn(
								"Failed to parse tag \"</"
									.. markupType .. ">\": \"" 
									.. markupType .. "\" is not a valid tag\n"
									.. self._renderTraceback
							)
						end

						i = tagEndPos + 1
					else
						local _, tagEndPos = string.find(t, "%s", i)
						warn(
							"Failed to parse tag \""
								.. string.sub(t, i, tagEndPos or #t)
								.. "\": no closing angle bracket found\n"
								.. self._renderTraceback
						)

						i = #t
					end
				end
			end
		end
		
		self._scheduler:Append(function()
			self:_Print()
		end)
	end
end

function HyperText._ApplyMarkup(
	self : classType,
	type_ : string,
	markupFormat : types.markup?,
	attrsFormat : types.attributes
)
	if self._markupHistory and self._renderMarkup and self._renderAttributes then
		local markup = markups[type_]
		
		local previousMarkup = markupFormat and util.updateMarkup(self._renderMarkup, markupFormat)
		local previousAttrs = util.updateAttributes(self._renderAttributes, attrsFormat)

		table.insert(self._markupHistory, 1, {type = type_, markup = previousMarkup, attributes = previousAttrs})
	end
end

function HyperText._RemoveMarkup(self : classType, type_ : string)
	if self._markupHistory and self._renderMarkup and self._renderAttributes then
		for i, v in ipairs(self._markupHistory) do
			if v.type == type_ then
				if v.markup then
					util.updateMarkup(self._renderMarkup, v.markup)
				end
				util.updateAttributes(self._renderAttributes, v.attributes)
				
				table.remove(self._markupHistory, i)
			end
		end
	end
end

function HyperText._Yield(self : classType, duration : number)
	local elapsed = 0

	while elapsed < duration and not self._ignoreIntervals do
		elapsed += RunService.RenderStepped:Wait()
	end
end

function HyperText._YieldWhile(
	self : classType,
	callback : (elapsed : number) -> boolean?
)
	local elapsed = 0
	
	while callback(elapsed) and not self._ignoreIntervals do
		elapsed += RunService.RenderStepped:Wait()
	end
end

function HyperText._Animate(
	self : classType,
	container : GuiObject,
	obj : TextLabel | ImageLabel,
	markup : types.markup,
	attributes : types.attributes
)
	if
		self._markupIndices
		and self._contentFolder
	then
		if markup.anim then
			local size = self:_GetProportionalSize()
			local parent = container.Parent :: GuiObject
			local loop = attributes.anim.loop
			local tweentrans = attributes.anim.tweentrans
			
			local tweenInfo : TweenInfo
			
			if markup.anim == "slide" then
				container.Position = attributes.slide.dir == "up"
					and UDim2.fromScale(
						(size * attributes.slide.offset) / parent.AbsoluteSize.X,
						(size * attributes.slide.offset) / parent.AbsoluteSize.Y
					)
					or UDim2.fromScale(
						(size * attributes.slide.offset) / parent.AbsoluteSize.X,
						(-size * attributes.slide.offset) / parent.AbsoluteSize.Y
					)
				container.Rotation = attributes.slide.dir == "up"
					and attributes.slide.rotation
					or -attributes.slide.rotation

				tweenInfo = TweenInfo.new(
					attributes.anim.dur,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.Out,
					loop and -1 or 0,
					loop and true or false
				)

				local containerTween = TweenService:Create(
					container,
					tweenInfo,
					{Position = UDim2.fromScale(0, 0), Rotation = 0}
				)
				containerTween:Play()

				self.onRenderEnded.Event:Once(function(stopped : boolean)
					if stopped and not loop then
						containerTween:Cancel()

						container.Position = UDim2.fromScale(0, 0)
						container.Rotation = 0
					end
				end)
			elseif markup.anim == "transparent" then
				if obj:IsA("TextLabel") then
					obj.TextTransparency = attributes.transparent.strength
				else
					obj.ImageTransparency = attributes.transparent.strength
				end

				local objTween = TweenService:Create(
					obj,
					TweenInfo.new(
						attributes.anim.dur,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.Out,
						loop and -1 or 0,
						loop and true or false
					),
					(
						obj:IsA("TextLabel")
							and {TextTransparency = markup.trans}
							or {ImageTransparency = markup.trans}
					) :: {[string] : any}
				)

				objTween:Play()

				self.onRenderEnded.Event:Once(function(stopped : boolean)
					if stopped and not loop then
						objTween:Cancel()

						if obj:IsA("TextLabel") then
							obj.TextTransparency = markup.trans
						else
							obj.ImageTransparency = markup.trans
						end
					end
				end)
			elseif markup.anim == "bounce" then
				container.Position = attributes.bounce.dir == "down"
					and UDim2.fromScale(0, (-size * attributes.bounce.offset) / parent.AbsoluteSize.Y)
					or UDim2.fromScale(0, (size * attributes.bounce.offset) / parent.AbsoluteSize.Y)

				tweenInfo = TweenInfo.new(
					attributes.anim.dur,
					Enum.EasingStyle.Bounce,
					Enum.EasingDirection.Out,
					loop and -1 or 0,
					loop and true or false
				)

				local containerTween = TweenService:Create(
					container,
					tweenInfo,
					{Position = UDim2.fromScale(0, 0)}
				)
				containerTween:Play()
				
				self.onRenderEnded.Event:Once(function(stopped : boolean)
					if stopped and not loop then
						containerTween:Cancel()

						container.Position = UDim2.fromScale(0, 0)
					end
				end)
			elseif markup.anim == "wiggle" then
				local updaterId = HttpService:GenerateGUID()
				local last = os.clock()
				local defaultPos = container.Position
				local duration = attributes.anim.dur
				local containerSize = container.AbsoluteSize
				local parentSize = parent.AbsoluteSize
				
				if not self._markupIndices[markup.anim] then
					self._markupIndices[markup.anim] = 0
				end
				
				local index = self._markupIndices[markup.anim]
				
				local containerCon = container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					containerSize = container.AbsoluteSize
				end)
				local parentCon = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					parentSize = parent.AbsoluteSize
				end)
				
				local function stop()
					containerCon:Disconnect()
					parentCon:Disconnect()
					
					container.Position = defaultPos
					updater[updaterId] = nil
				end
				
				updater[updaterId] = function()
					debug.profilebegin("Wiggle Animation Markup")

					local time_ = os.clock()
					local elapsed = time_ - last
					local yOffset = math.sin(
						(time_ / (loop and duration or 1 / attributes.wiggle.freq) * math.pi * 2)
							+ (math.pi * 2 * attributes.wiggle.offset * index) -- offset between characters
					) 
						* (loop and 1 or (1 - (elapsed / duration))) -- fades out if not looping
						* attributes.wiggle.amp * containerSize.Y
					container.Position = defaultPos + UDim2.fromScale(0, yOffset/parentSize.Y)

					if elapsed >= duration and not loop then
						stop()
					end

					debug.profileend()
				end
								
				self.onRenderEnded.Event:Once(function(stopped : boolean)
					if stopped and not loop then
						stop()
					end
				end)
				self._contentFolder.Destroying:Once(function()
					stop()
				end)
				
				self._markupIndices[markup.anim] += 1
			end
			
			if tweentrans and markup.anim ~= "transparent" then
				if obj:IsA("TextLabel") then
					obj.TextTransparency = 1
				else
					obj.ImageTransparency = 1
				end

				local objTween = TweenService:Create(
					obj,
					markup.anim ~= "wiggle"
						and tweenInfo
						or TweenInfo.new(
							attributes.anim.dur,
							Enum.EasingStyle.Linear,
							Enum.EasingDirection.Out
						),
					(
						obj:IsA("TextLabel")
							and {TextTransparency = markup.trans}
							or {ImageTransparency = markup.trans}
					) :: {[string] : any}
				)
				objTween:Play()

				self.onRenderEnded.Event:Once(function(stopped : boolean)
					if stopped and not loop and tweentrans then
						objTween:Cancel()

						if obj:IsA("TextLabel") then
							obj.TextTransparency = markup.trans
						else
							obj.ImageTransparency = markup.trans
						end
					end
				end)
			end
		end
	end
end

local function getEmitImageUpdater(
	container : GuiObject,
	id : number,
	attributes : typeof(config.DEFAULT_ATTRIBUTES.emitimg)
)
	local interval = 1 / attributes.rate
	local last = os.clock() - math.random() * interval

	local images : {
		[ImageLabel] : {
			vel : Vector2,
			accel : Vector2,
			rotvel : number,
		}	
	} = {}

	return images, function(dt : number)
		debug.profilebegin("Emit Image Markup")

		for img, data in pairs(images) do
			img.Position += UDim2.fromScale(
				data.vel.X * dt,
				data.vel.Y * dt
			)

			data.vel += Vector2.new(
				data.accel.X * dt,
				data.accel.Y * dt
			)

			img.Rotation += data.rotvel * dt
		end

		local c = os.clock()
		if c - last >= interval then
			last = c

			if math.random() * 100 <= attributes.chance then
				local img = Instance.new("ImageLabel", container)
				img.ImageColor3 = attributes.color
				img.AnchorPoint = Vector2.new(.5, .5)
				img.Image = "rbxassetid://" .. id
				img.BackgroundTransparency = 1
				img.ImageTransparency = util.getRandomFromRange(attributes.starttrans)
				img.Position = UDim2.fromScale(.5, .5) + UDim2.fromScale(
					util.getRandomFromRange(attributes.startposx),
					util.getRandomFromRange(attributes.startposy)
				)
				img.Rotation = util.getRandomFromRange(attributes.startrot)
				img.SizeConstraint = Enum.SizeConstraint.RelativeYY

				local endSize = util.getRandomFromRange(attributes.endsize)
				local size = util.getRandomFromRange(attributes.startsize) 
				img.Size = UDim2.fromScale(size * attributes.aspectratio, size)

				local vel = Vector2.new(
					util.getRandomFromRange(attributes.velx),
					util.getRandomFromRange(attributes.vely)
				)
				local accel = Vector2.new(
					util.getRandomFromRange(attributes.accelx),
					util.getRandomFromRange(attributes.accely)
				)
				local rotvel = util.getRandomFromRange(attributes.rotvel)

				local lifetime = util.getRandomFromRange(attributes.lifetime)
				local tween = TweenService:Create(
					img,
					TweenInfo.new(lifetime),
					{
						Size = UDim2.fromScale(endSize * attributes.aspectratio, endSize),
						ImageTransparency = util.getRandomFromRange(attributes.endtrans)
					}
				)

				images[img] = {
					vel = vel,
					accel = accel,
					rotvel = rotvel,
				}

				tween.Completed:Once(function()
					img:Destroy()

					images[img] = nil
				end)
				tween:Play()
			end
		end

		debug.profileend()
	end
end

function HyperText._ApplyEffect(
	self : classType,
	container : GuiObject,
	obj : TextLabel | ImageLabel,
	markup : types.markup,
	attributes : types.attributes
)
	if 
		self._markupIndices
		and self._contentFolder
	then
		local size = self:_GetProportionalSize()
		local parent = container.Parent :: GuiObject
		
		if markup.shake then
			local updaterId = HttpService:GenerateGUID()
			local last = os.clock()
			local loop = attributes.shake.loop
			local duration = attributes.shake.dur
			local defaultPos = container.Position
			local containerSize = container.AbsoluteSize
			local parentSize = parent.AbsoluteSize

			container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				containerSize = container.AbsoluteSize
			end)
			parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				parentSize = parent.AbsoluteSize
			end)
			
			local function stop()
				updater[updaterId] = nil
				container.Position = defaultPos
			end
			
			updater[updaterId] = function()
				debug.profilebegin("Shake Markup")
				
				local offset = attributes.shake.maxoffset * containerSize.Y
				local yOffset = offset * math.random(-100, 100)/100
				local xOffset = offset * math.random(-100, 100)/100
				
				local time_ = os.clock()
				local elapsed = time_ - last
				
				container.Position = defaultPos + UDim2.fromScale(
					xOffset/parent.AbsoluteSize.X * (loop and 1 or (1 - (elapsed / duration))),
					yOffset/parentSize.Y * (loop and 1 or (1 - (elapsed / duration)))
				)
				
				if elapsed >= duration and not loop then
					stop()
				end
				
				debug.profileend()
			end

			self.onRenderEnded.Event:Once(function(stopped : boolean)
				if stopped and not loop then
					stop()
				end
			end)
			self._contentFolder.Destroying:Once(function()
				stop()
			end)
		end
		
		if markup.rainbow then
			local updaterId = HttpService:GenerateGUID()

			if not self._markupIndices["rainbow"] then
				self._markupIndices["rainbow"] = 0
			end

			local index = self._markupIndices["rainbow"]

			updater[updaterId] = function(dt : number)
				debug.profilebegin("Rainbow Markup")
				
				local color = Color3.fromHSV(
					(
						os.clock() * attributes.rainbow.freq -
							attributes.rainbow.offset * index
					) % 1,
					1,
					1
				)
				
				if obj:IsA("TextLabel") then
					obj.TextColor3 = color
				else
					obj.ImageColor3 = color
				end

				debug.profileend()
			end
			
			self._contentFolder.Destroying:Once(function()
				updater[updaterId] = nil
			end)

			self._markupIndices["rainbow"] += 1
		end
		
		if markup.emitimg then
			local updaterId = HttpService:GenerateGUID()
			local images, callback = getEmitImageUpdater(
				container,
				markup.emitimg,
				table.clone(attributes.emitimg)
			)
			
			updater[updaterId] = callback
			
			self._contentFolder.Destroying:Once(function()
				updater[updaterId] = nil
			end)
		end
		
		if markup.shiny then
			local updaterId = HttpService:GenerateGUID()
			local images, callback = getEmitImageUpdater(
				container,
				config.SHINY_IMG_ID,
				config.SHINY_EMIT_ATTRS
			)

			updater[updaterId] = callback

			self._contentFolder.Destroying:Once(function()
				updater[updaterId] = nil
			end)
		end
		
		if markup.fog then
			local updaterId = HttpService:GenerateGUID()
			local images, callback = getEmitImageUpdater(
				container,
				config.FOG_IMG_ID,
				setmetatable({
					color = attributes.fog.color
				} :: typeof(config.DEFAULT_ATTRIBUTES.emitimg), {__index = config.FOG_EMIT_ATTRS}) :: any
			)

			updater[updaterId] = callback

			self._contentFolder.Destroying:Once(function()
				updater[updaterId] = nil
			end)
		end
	end
end

RunService.Heartbeat:Connect(function(dt)
	debug.profilebegin("HyperText Updater")
	
	for id, callback in pairs(updater) do
		if updater[id] then
			local success, errmsg = pcall(callback, dt)

			if not success then
				warn("HyperText updater callback error: " .. errmsg :: string)
			end
		end
	end

	debug.profileend()
end)

return HyperText