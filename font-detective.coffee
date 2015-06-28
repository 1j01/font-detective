
# Dependencies
swfobject = require "swfobject"

# Helpers
after = (ms, fn)-> tid = setTimeout fn, ms; stop: -> clearTimeout tid
every = (ms, fn)-> iid = setInterval fn, ms; stop: -> clearInterval iid

# http://www.dustindiaz.com/smallest-domready-ever
domReady = (callback)->
	if /in/.test document.readyState
		after 10, -> domReady callback
	else
		callback()


do (exports = window)->
	
	# Namespace
	FD = exports.FontDetective = {}
	
	# Configuration
	FD.swf = "./flash/FontList.swf"
	
	# The generic font-family keywords defined by CSS
	genericFontFamilies = [
		"serif" # (e.g. Times)
		"sans-serif" # (e.g. Helvetica)
		"cursive" # (e.g. Zapf-Chancery)
		"fantasy" # (e.g. Western)
		"monospace" # (e.g. Courier)
	]
	
	# A list of common fonts, somewhat biased towards Windows
	someCommonFontNames =
		"Helvetica,Lucida Grande,Lucida Sans,Tahoma,Arial,Geneva,Monaco,Verdana,Microsoft Sans Serif,Trebuchet MS,Courier New,Times New Roman,Courier,Lucida Bright,Lucida Sans Typewriter,URW Chancery L,Comic Sans MS,Georgia,Palatino Linotype,Lucida Sans Unicode,Times,Century Schoolbook L,URW Gothic L,Franklin Gothic Medium,Lucida Console,Impact,URW Bookman L,Helvetica Neue,Nimbus Sans L,URW Palladio L,Nimbus Mono L,Nimbus Roman No9 L,Arial Black,Sylfaen,MV Boli,Estrangelo Edessa,Tunga,Gautami,Raavi,Mangal,Shruti,Latha,Kartika,Vrinda,Arial Narrow,Century Gothic,Garamond,Book Antiqua,Bookman Old Style,Calibri,Cambria,Candara,Corbel,Monotype Corsiva,Cambria Math,Consolas,Constantia,MS Reference Sans Serif,MS Mincho,Segoe UI,Arial Unicode MS,Tempus Sans ITC,Kristen ITC,Mistral,Meiryo UI,Juice ITC,Papyrus,Bradley Hand ITC,French Script MT,Malgun Gothic,Microsoft YaHei,Gisha,Leelawadee,Microsoft JhengHei,Haettenschweiler,Microsoft Himalaya,Microsoft Uighur,MoolBoran,Jokerman,DFKai-SB,KaiTi,SimSun-ExtB,Freestyle Script,Vivaldi,FangSong,MingLiU-ExtB,MingLiU_HKSCS,MingLiU_HKSCS-ExtB,PMingLiU-ExtB,Copperplate Gothic Light,Copperplate Gothic Bold,Franklin Gothic Book,Maiandra GD,Perpetua,Eras Demi ITC,Felix Titling,Franklin Gothic Demi,Pristina,Edwardian Script ITC,OCR A Extended,Engravers MT,Eras Light ITC,Franklin Gothic Medium Cond,Rockwell Extra Bold,Rockwell,Curlz MT,Blackadder ITC,Franklin Gothic Heavy,Franklin Gothic Demi Cond,Lucida Handwriting,Segoe UI Light,Segoe UI Semibold,Lucida Calligraphy,Cooper Black,Viner Hand ITC,Britannic Bold,Wide Latin,Old English Text MT,Broadway,Footlight MT Light,Harrington,Snap ITC,Onyx,Playbill,Bauhaus 93,Baskerville Old Face,Algerian,Matura MT Script Capitals,Stencil,Batang,Chiller,Harlow Solid Italic,Kunstler Script,Bernard MT Condensed,Informal Roman,Vladimir Script,Bell MT,Colonna MT,High Tower Text,Californian FB,Ravie,Segoe Script,Brush Script MT,SimSun,Arial Rounded MT Bold,Berlin Sans FB,Centaur,Niagara Solid,Showcard Gothic,Niagara Engraved,Segoe Print,Gabriola,Gill Sans MT,Iskoola Pota,Calisto MT,Script MT Bold,Century Schoolbook,Berlin Sans FB Demi,Magneto,Arabic Typesetting,DaunPenh,Mongolian Baiti,DokChampa,Euphemia,Kalinga,Microsoft Yi Baiti,Nyala,Bodoni MT Poster Compressed,Goudy Old Style,Imprint MT Shadow,Gill Sans MT Condensed,Gill Sans Ultra Bold,Palace Script MT,Lucida Fax,Gill Sans MT Ext Condensed Bold,Goudy Stout,Eras Medium ITC,Rage Italic,Rockwell Condensed,Castellar,Eras Bold ITC,Forte,Gill Sans Ultra Bold Condensed,Perpetua Titling MT,Agency FB,Tw Cen MT,Gigi,Tw Cen MT Condensed,Aparajita,Gloucester MT Extra Condensed,Tw Cen MT Condensed Extra Bold,PMingLiU,Bodoni MT,Bodoni MT Black,Bodoni MT Condensed,MS Gothic,GulimChe,MS UI Gothic,MS PGothic,Gulim,MS PMincho,BatangChe,Dotum,DotumChe,Gungsuh,GungsuhChe,MingLiU,NSimSun,SimHei,DejaVu Sans,DejaVu Sans Condensed,DejaVu Sans Mono,DejaVu Serif,DejaVu Serif Condensed,Eurostile,Matisse ITC,Bitstream Vera Sans Mono,Bitstream Vera Sans,Staccato222 BT,Bitstream Vera Serif,Broadway BT,ParkAvenue BT,Square721 BT,Calligraph421 BT,MisterEarl BT,Cataneo BT,Ruach LET,Rage Italic LET,La Bamba LET,Blackletter686 BT,John Handy LET,Scruff LET,Westwood LET"
			.split(",")
			.sort()
	
	
	swfFonts = []
	testedFonts = []
	doneTestingFonts = no
	
	# The container for all font-detective related uglyness
	container = document.createElement "div"
	container.id = "font-detective"
	# The document body won't always exist at this point, so append this later
	
	# An element whose only purpose is to be replaced (how sad)
	dummy = document.createElement "div"
	dummy.id = "font-detective-dummy"
	container.appendChild dummy
	
	# The ID of the flash <object>
	swfId = "font-detective-flash"
	
	
	###
	# A font class that can be stringified for use in css
	# e.g. font.toString() or (font + ", sans-serif")
	###
	class Font
		constructor: (@name, @type, @style)->
		toString: ->
			# Escape \ to \\ before escaping " to \" (so " doesn't become \\"), and surround with quotes
			'"' + @name.replace(/\\/g, "\\\\").replace(/"/g, "\\\"") + '"'
	
	# Based off of http://www.lalit.org/lab/javascript-css-font-detect
	fontAvailabilityChecker = do ->
		
		# A font will be compared against three base fonts
		# If it differs from one of the base measurements
		# (which implies it didn't fall back to the base font), then the font is available
		baseFontFamilies = ["monospace", "sans-serif", "serif"]
		
		# We use m or w because they take up the maximum width
		# We use thin letters so that some matching fonts can get separated
		testString = "mmmmmmmmmmlli"
		
		# We test using 72px font size; the bigger the better
		testSize = "72px"
		
		# Create a span in the document to get the width of the text we use to test
		span = document.createElement "span"
		span.innerHTML = testString
		span.style.fontSize = testSize
		baseWidths = {}
		baseHeights = {}
		
		init: ->
			# Call this method once the document has a body
			document.body.appendChild container
			
			# Get the dimensions of the three base fonts
			for baseFontFamily in baseFontFamilies
				span.style.fontFamily = baseFontFamily
				container.appendChild span
				baseWidths[baseFontFamily] = span.offsetWidth
				baseHeights[baseFontFamily] = span.offsetHeight
				container.removeChild span
		
		check: (font)->
			# Check whether a font is available
			for baseFontFamily in baseFontFamilies
				span.style.fontFamily = "#{font}, #{baseFontFamily}"
				container.appendChild span
				differs = (
					span.offsetWidth isnt baseWidths[baseFontFamily] or
					span.offsetHeight isnt baseHeights[baseFontFamily]
				)
				container.removeChild span
				
				return yes if differs
			return no
	
	class FontListSWF
		constructor: ->
			@callbacks = []
			@loading = no
			@loaded = no
			@failed = no
		
		load: (callback)->
			if @loaded
				callback null, @swf
			else
				@callbacks.push callback
				
				unless @loading or @loaded or @failed
					@loading = yes
					domReady =>
						
						flashvars = swfObjectId: swfId
						params = allowScriptAccess: "always", menu: "false"
						attributes = id: swfId, name: swfId
						
						embedCallback = (e)=>
							@loading = no
							if e.success
								@swf = e.ref
								@loaded = yes
							else
								@failed = yes
							for cb in @callbacks
								if e.success
									cb null, @swf
								else
									cb new Error "Failed to load the SWF Object"
						
						document.body.appendChild container
						
						# That is one dubious function signature
						swfobject.embedSWF(
							FD.swf # the URL of the SWF file
							dummy.id # the id of the element to be replaced by the Flash content
							"1", "1" # width and height of the SWF
							"9.0.0" # the Flash player version the SWF is published for
							no # (optional) URL of an express install SWF and activates Adobe express install
							flashvars # generates a <param name="flashvars" value="..."> element
							params # generates <param> elements within the <object> element
							attributes # sets attributes on the <object> element
							embedCallback # a callback function that is called on both success or failure
						)
	
	fontListSWF = new FontListSWF
	
	loadFonts = ->
		
		fallback = ->
			FD.incomplete = true
			testFonts (new Font(fontName) for fontName in someCommonFontNames)
		
		fontListSWF.load (err, swf)->
			if err
				fallback()
			else
				timeout = after 2000, ->
					interval?.stop()
					fallback()
				
				interval = every 50, ->
					if swf.fonts
						interval?.stop()
						timeout?.stop()
						testFonts(
							for {fontName, fontType, fontStyle} in swf.fonts()
								new Font fontName, fontType, fontStyle
						)
	
	testFonts = (fonts)->
		fontAvailabilityChecker.init()
		
		for font in fonts
			available = fontAvailabilityChecker.check font
			if available
				testedFonts.push font
				for callback in FD.each.callbacks
					callback font
		
		for callback in FD.all.callbacks
			callback testedFonts
		
		FD.all.callbacks = []
		FD.each.callbacks = []
		doneTestingFonts = yes
	
	
	###
	# FontDetective.preload()
	# Starts detecting fonts early
	###
	FD.preload = loadFonts
	
	###
	# FontDetective.each(function(font){})
	# Calls back with a `Font` every time a font is detected and tested
	###
	FD.each = (callback)->
		callback font for font in testedFonts
		unless doneTestingFonts
			FD.each.callbacks.push callback
			loadFonts()
	
	FD.each.callbacks = []
	
	
	###
	# FontDetective.all(function(fonts){})
	# Calls back with an `Array` of `Font`s when all fonts are detected and tested
	###
	FD.all = (callback)->
		if doneTestingFonts
			callback testedFonts
		else
			FD.all.callbacks.push callback
			loadFonts()
	
	FD.all.callbacks = []
