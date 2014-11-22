# Font Detective

Uses JavaScript + Flash to detect your system fonts.

	<script src="lib/swfobject.js"></script>
	<script src="lib/font-detective.js"></script>
	<script>
		$(document).ready(function() {
			FontDetective.swf = "custom/path/to/FontList.swf";
			
			FontDetective.each(function(font){
				$("<option>").val(font).text(font.name).appendTo("select");
				font; // e.g. '"Arial"'
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
