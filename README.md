
# ![Font Detective](img/font-detective.png)

> **Note:** v1.x supported getting a full list of fonts with Flash; v2.x drops support for Flash.

Detects your system fonts with JavaScript, from a list of common fonts.

See a nice [demo](http://1j01.github.io/font-detective).
You can edit the sample text.

```html
<script src="lib/font-detective.js"></script>
<script>
	FontDetective.each(function(font){
		$("<option>")
			.val(font)
			.text(font.name)
			.appendTo("select");
		
		font.name; // e.g. 'Arial'
		font.toString(); // e.g. '"Arial"'
	});
	
	FontDetective.all(function(fonts){
		console.log(fonts);
	});
</script>
```

## Documentation

### `FontDetective.each(callback)`
* Calls back with a `Font` every time a font is detected and tested

### `FontDetective.all(callback)`
* Calls back with an `Array` of `Font`s when all fonts are detected and tested

### `FontDetective.preload()`
* Starts detecting fonts immediately

### `FontDetective.Font`
* Fonts are returned as instances of this class
* The `font.name` property can be used to display the name of the font
* The `font` can be used anywhere you'd use a `font-family`
  (e.g. `div.style.fontFamily = font`)

## Node.js

For detecting fonts from Node.js, see [font-manager](https://github.com/devongovett/font-manager)

## License

MIT-licensed, see [LICENSE](LICENSE) for details
