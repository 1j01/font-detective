
# ![Font Detective](img/font-detective.png)

Detects your system fonts with Flash + JavaScript.

If Flash is unavailable, it will fall back to a testing fonts from a list of common fonts.

For Flash to work, the page should be served from a web server, i.e. not `file://`

See a nice [demo](http://1j01.github.io/font-detective).
You can edit the sample text.

```html
<script src="lib/font-detective.js"></script>
<script>
	FontDetective.swf = "custom/path/to/FontList.swf";
	
	FontDetective.each(function(font){
		$("<option>")
			.val(font)
			.text(font.name)
			.appendTo("select");
		
		font.name; // e.g. 'Arial'
		font.style; // e.g. 'regular'
		font.type; // e.g. 'device'
		
		font.toString(); // e.g. '"Arial"'
	});
	
	FontDetective.all(function(fonts){
		console.log(fonts);
	});
</script>
```


## Documentation

### `FontDetective.each(function(font){})`
* Calls back with a `Font` every time a font is detected and tested

### `FontDetective.all(function(fonts){})`
* Calls back with an `Array` of `Font`s when all fonts are detected and tested

### `FontDetective.swf`
* The location of the `FontList.swf` file, defaulting to `"./flash/FontList.swf"`

### `FontDetective.incomplete`
* In a callback, indicates that a fallback was used,
  and that the results are not the complete set of available fonts

### `class FontDetective.Font`
* Fonts are returned as instances of this class
* The `font.name` property can be used to display the name of the font
* The `font.style` property will probably always be `"regular"`
* The `font.type` property will probably always be `"device"`
* The font can be used anywhere you'd use a `font-family`
  (e.g. `div.style.fontFamily = font`)


## Todo

* Start testing common fonts immediately (i.e. before loading or giving up loading with Flash),
  calling `each` callbacks, but waiting for Flash success or failure for `all` callbacks
  (and making sure not to check or return the same font twice)

* Detect fonts in Node.js with [font-manager](https://github.com/devongovett/font-manager)
  (It might be best to package two separate versions of font-detective though,
  so the browser version doesn't depend on a native module.)
