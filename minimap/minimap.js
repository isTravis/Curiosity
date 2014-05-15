$(document).ready(function() {
	$( "#slider" ).draggable({ containment: "#minimap", scroll: false });
});


var resizedMap = function(fullDimensions, currentPosition, currentZoom){
	// fullDimensions = [fullWidth, fullHeight]
	// currentDimensions = [currentWidth, currentHeight]
	// currentPosition: [xPosition, yPosition] of top left corner in px.
	// currentZoom = 1.0 for full size 

	// dimensions of screen basically. 
	var fullWidth = fullDimensions[0], fullHeight = fullDimensions[1];

	// x and y position of top left corner of slider in minimap
	var xPosition = currentPosition[0], yPosition = currentPosition[1];

	// constant size ratio for minimap. Not sure what size
	var minimapHeight = fullHeight*.2;
	var minimapWidth = fullWidth*.2;

	//fullMap
	document.getElementById('fullMap').style.height = fullHeight + 'px';
	document.getElementById('fullMap').style.width = fullWidth + 'px';

	//minimap
	document.getElementById('minimap').style.height = minimapHeight + 'px';
	document.getElementById('minimap').style.width = minimapWidth + 'px';

	//slider size
	document.getElementById('slider').style.height = minimapHeight/currentZoom + 'px';
	document.getElementById('slider').style.width = minimapWidth/currentZoom + 'px';

	//slider position
	document.getElementById('slider').style.left = xPosition*.2 + 'px';
	document.getElementById('slider').style.top = yPosition*.2 + 'px';

	return [[fullWidth, fullHeight], [xPosition, yPosition], currentZoom];
}

