
# ![Font Detective](img/font-detective.png)

Uses JavaScript + Flash to detect your system fonts.

If Flash is unavailable, it will fall back to a list of common fonts.
Either way, it tests each font to make sure it's available for use.
For Flash to work, the page should be served from a web server, i.e. not `file://`

See a nice [demo](http://1j01.github.io/font-detective).

```html
<script src="lib/swfobject.js"></script>
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
		font + ", sans-serif"; // e.g. '"Arial", sans-serif'
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

### `class FontDetective.Font`
* The `font.name` property can be used to display the name of the font
* The `font.style` property will probably always be `"regular"`
* The `font.type` property will probably always be `"device"`
* The font, when stringified
  (e.g. `font.toString()` or `(font + ", sans-serif")`),
  will yield a valid CSS font-family value
  (even if the font name contains commas and quotes)


## Todo

* Publish `font-detective@1.0.0`

* Add "Fork me on Github" ribbon

* Start testing common fonts immediately (i.e. before loading or giving up loading with Flash),
  calling `each` callbacks, but waiting for Flash success or failure for `all` callbacks
  (making sure not to check or return the same font twice)

* Detect fonts in Node.js with [font-manager](https://github.com/devongovett/font-manager)
  (It might be best to package two separate versions though,
  so the browser version doesn't depend on a native module.)
