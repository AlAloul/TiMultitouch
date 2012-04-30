// Copyright (c) 2012, Uri Shaked.
// Simple usage example for Titanium Multitouch module.

Ti.UI.setBackgroundColor('#000');

var window = Ti.UI.createWindow({
	backgroundColor : '#000'
});

var pointViews = {};

/* --- INTERESTING CODE STARTS HERE --- */

// Step 1: Load the multitouch module
require("org.urish.titanium.multitouch");

// Step 2: Enable multitouch for the main window
window.multitouch = true;

// Step 3: Add event listeners to the view
window.addEventListener('touchstart', function(event) {
	Ti.API.info(event);
	for(var point in event.points) {
		var radius = 30;
		var view = Ti.UI.createView({
			width : radius * 2,
			height : radius * 2,
			borderRadius : radius,
			backgroundColor : '#00a000',
			center : {
				x : event.points[point].x,
				y : event.points[point].y
			}
		});
		pointViews[point] = view;
		window.add(view);
	}
});

window.addEventListener('touchmove', function(event) {
	Ti.API.info(event);
	for(var point in event.points) {
		pointViews[point].center = {
			x : event.points[point].x,
			y : event.points[point].y
		};
	}
});

window.addEventListener('touchend', function(event) {
	Ti.API.info(event);
	for(var point in event.points) {
		window.remove(pointViews[point]);
		delete pointViews[point];
	}
});

window.addEventListener('touchcancel', function(event) {
	Ti.API.info(event);
	for(var point in event.points) {
		window.remove(pointViews[point]);
		delete pointViews[point];
	}
});

window.open();
