--[[	v1.0.0		23-12-2025
	
	release

]]

--[[ 	v2.0.0		9-2-2026

	FIXES:
	
		fixed a bug where where all animations would stop immediately when a render ended
		fixed a few other minor rendering bugs

	CHANGES:
	
		changed name to HyperText
		changed :GetRenderedDimensions() to :GetRenderedTextBounds()
		changed typewriterinterval markup to interval
		changed transparency markup to trans
		changed typewritersoundid markup to soundid
		changed .newProperties() to .newMarkup() and have it's content resemble actual markup tags
		changed :UpdateProperties() to :UpdateDefaultMarkup() and allow it to update attributes as well
		changed the naming convention for all values of anim markup from PascalCase to fully lowercase
		
		removed the stinky effect, use the new fog markup with a green color attribute instead
		removed config.REFERENCE_SIZE
		removed "None" value for anim markup, remove these markups instead by giving it a value of "/"
		removed animloop and animduration markup, use the dur and loop attributes of the anim markup
		for this instead
		removed all config values for animations and effects, alter the default attribute values instead
		removed FromTop and FromBottom from certain animations, use the dir attribute instead
		removed the effect markup, instead each effect is now an individual markup, so it's possible to
		stack them
		removed config.TYPEWRITER_SFX_VOLUME, change the default value of the volume attribute of the
		typewritersoundid markup instead
		
	ADDITIONS:
	
		improved TextBounds cache retrieval

		added a new markup called zindex (does not use tags) which determines the z index of
		all rendered GuiObjects, meant for use cases where the ZIndexBehaviour of the ScreenGui
		in which the container is nested in is set to Global. Defaults to 1. (credits to @maxencexz!)
		
		added a .newAttributes() function which gives you an empty dict typed as attributes
		which you can pass to the constructor or :UpdateDefaultMarkup()

		it's now also possible to add attributes to markup tags (e.g. <anim=wiggle dur=5 loop=true>)
		
		added the emitimg markup
		added the img markup
		added the stroke markup
		added the underline markup
		added the strike markup
		added the mark markup
		added the fog markup
]]

--[[	v2.0.1		14-2-2026

	FIXES:
		fixed a bug where the wait markup, placed directly after text, would wait before the text printed

	CHANGES:
		capitalization concering tags, attributes or values in a render's text now don't matter anymore

]]

--[[	v2.0.2		28-2-2026

	FIXES:
		fixed a non-breaking error when clearing any render

	CHANGES:
		soundid markup now allows for numbers and strings, so rbxassetid://123 and 123 are valid
		render's are now only possible when an object's container has an absolute width AND height above 0 which could otherwise yield unwanted behaviour

]]

--[[	v2.0.3		28-3-2026		

	ADDITIONS:
		documented some markups which werent documented before
		added a new markup called scaleDimension which doesn't use tags

	FIXES:
		fixed a bug where a non looping shake markup would keep characters scattered when completing a render

]]

--[[	v2.0.4		28-3-2026

	ADDITIONS:
		added 2 new examples in the demo folder which shows how to render inside a container with AutomaticSize
		added a height attribute to the img markup
		added a new markup called sizeConstraint which doesn't use tags

	FIXES:
		fixed a bug where images would scale up when bigger text is printed after it
		fixed a bug where attributes of values were not recognized

]]

--[[	v2.0.5		3-4-2026

	ADDITIONS:
		added a new attribute plain to the img markup which prevents animations and effects to be applied to it
		added the trans attribute to the stroke markup 

	CHANGES:
		onRenderEnded now ignores pre-renders
		
		when rendering in a container with absolute size enabled on one of its axis,
		that axis is now allowed to have an absolute size of 0 (only when the sizeConstraint
		markup is set correctly!)
		
		img markup now allows for the current animation and active effects to be applied to the image
		(use the new plain attribute if you do not want this)
		
		when wrapping is enabled, the img markup now checks whether the image fits on the current line, if not, it creates a new line
		
	FIXES:
		fixed a bug where when an image gets added at the start of a line it doesn't show up
		fixed a bug where where a really tall image might extend into other lines
		fixed a bug where an image from the img markup would receive an incorrect zindex
		fixed a bug where overflow warnings on the x axis would not be shown
]]

--[[	v2.0.6		4-4-2026

	CHANGES:
		the font markup now allows for numbers and strings, so rbxassetid://123 and 123 are valid

	FIXES:
		fixed a bug where if you'd assign a number to the soundid markup in a text it'd fail to load the sound
		fixed a bug where the warning for a failed parsing attempt of an attribute would error 
		fixed several minor rendering bugs
		
]]