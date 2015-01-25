
# ![Font Detective](img/font-detective.png)

Uses JavaScript + Flash to detect your system fonts.

	<script src="lib/swfobject.js"></script>
	<script src="lib/font-detective.js"></script>
	<script>
		$(document).ready(function() {
			FontDetective.swf = "custom/path/to/FontList.swf";
			
			FontDetective.each(function(font){
				$("<option>").val(font).text(font.name).appendTo("select");
				font.toString(); // e.g. '"Arial"'
				font.name; // e.g. 'Arial'
				font.style; // e.g. 'regular'
				font.type; // e.g. 'device'
			});
			
			FontDetective.all(function(fonts){
				console.log(fonts);
			});
			
			$select.click(function(){
				// omg they're actually clicking on it; quick load some fonts!
				FontDetective.load();
				// (or you can call load earlier)
			});
		});
	</script>


## Documentation

### `FontDetective.each(function(font){})`
* Calls back with a `Font` every time a font is detected and tested

### `FontDetective.all(function(fonts){})`
* Calls back with an `Array` of `Font`s when all fonts are detected and tested

### `FontDetective.load()`
* Load the SWF object and start detecting fonts

### `FontDetective.swf`
* The location of the `FontList.swf` file, defaulting to `"./flash/FontList.swf"`

### `class Font`
* The `font.name` property can be used to display the name of the font
* The `font.style` property will probably always be `"regular"`
* The `font.type` property will probably always be `"device"`
* The font can be stringified and will be escaped for use in css, e.g. `font.toString()` or `(font + ", sans-serif")`


## Todo

* Check for common fonts even when Flash is unavailable

* Add an optional argument to `FontDetective.load` that deprecates setting `FontDetective.swf`

* Allow chaining? Load automatically?

