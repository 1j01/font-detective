
# ![Font Detective](img/font-detective.png)

Uses JavaScript + Flash to detect your system fonts.

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

* Check for common fonts even when Flash is unavailable

* If there's a reasonable way to detect fonts in node.js...
  like a simple [module](https://github.com/devongovett/font-manager) I could depend on,
  that could be cool.
  I might want to package two separate versions though,
  so the browser version doesn't depend on some native module.
