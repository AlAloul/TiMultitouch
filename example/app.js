// Copyright (c) 2011, Uri Shaked.
// Based on code originally written by masuidrive.

Ti.UI.setBackgroundColor('#000');

// Step 1: Load the multitouch module
require("org.urish.titanium.multitouch");

var window = Ti.UI.createWindow({  
	backgroundColor:'#fff',
	fullscreen: true
});

var scale = 1.0;

function calcDistance(x1, y1, x2, y2) {
	return Math.sqrt(Math.pow(x2-x1,2)+Math.pow(y2-y1,2));
}

var imageView = Ti.UI.createImageView({
	image: "sample.jpg",
	transform: Ti.UI.create2DMatrix().scale(scale)
});
window.add(imageView);


window.addEventListener('singletap', function(ev) {
	// DON'T REMOVE THIS LISTENER!!
	// Hack for the multi touch module. If you remove this, some of the touchend events
	// may not be fired at all!
});

var start_scale = scale;
var distance = 0.0;
var touchstart_point = {x:0, y:0};
var touchstart_view = {left:0, top:0};

function extractPoints(ev) {
	var result = [];
	for (var key in ev.points) {
		result.push(ev.points[key]);
	}
	return result;
}

window.addEventListener('touchstart', function(ev) {
	Ti.API.info(ev);
	var pointArray = extractPoints(ev);
	if (pointArray.length > 1) {
		start_scale = scale;
		distance = calcDistance(pointArray[0].x,pointArray[0].y, pointArray[1].x, pointArray[1].y);
	} else {
		touchstart_point.x = ev.x;
		touchstart_point.y = ev.y;
		touchstart_view.left = imageView.left || 0;
		touchstart_view.top = imageView.top || 0;
	}
});
window.addEventListener('touchmove', function(ev) {
	Ti.API.info(ev);
	var pointArray = extractPoints(ev);
	if (pointArray.length > 1) {
		scale = start_scale * (calcDistance(pointArray[0].x, pointArray[0].y, pointArray[1].x, pointArray[1].y) / distance);
		imageView.transform = Ti.UI.create2DMatrix().scale(scale);
	} else {
		imageView.left = touchstart_view.left + (ev.x - touchstart_point.x);
		imageView.top = touchstart_view.top + (ev.y - touchstart_point.y); 
	}
});

window.addEventListener('touchend', function(ev) {
	Ti.API.info(ev);
});

window.addEventListener('touchcancel', function(ev) {
	Ti.API.info(ev);
});

window.open();
