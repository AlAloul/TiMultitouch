# Multitouch Module

## Description

Handle multi touch events inside your iOS applications.

## Accessing the multitouch Module

First of all, add the multitouch module to your applications tiapp.xml by adding the following
line inside the `<modules>` tag:

	<module version="1.1">org.urish.titanium.multitouch</module>

To load the module, add the following line to your javascript code:

	require("org.urish.titanium.multitouch");

## Reference

You can enable multitouch for any window or view. First of all, add an empty event listener to the 'singletap' event 
(see example below). Then add listeners to the standard touchstart/touchmove/touchend/touchcancel events. These events
will now contain a new field called "points".

The "points" fields is actually a dictionary with information about the touches. Each touch has a unique id which can be used to track the specific touch across several touch events. The dictionary contains the touch id as the key of the entry, and an object contains 'x' and 'y' properties as the value.

The 'x' and 'y' properties for each touch are relative to the view. You can also get the global coordinates of the
touch event by looking into the 'globalPoint' property.

## Usage

	require("org.urish.titanium.multitouch");
	
	win.addEventListener('singletap', function(event) {
		// DON'T REMOVE THIS LISTENER!!
		// hack for multi touch module
	});
	
	win.addEventListener("touchstart", function(event) {
		Ti.API.info("Touches started, points: " + JSON.stringify(event.points));
		
		// Sample code for interating the points:
		for (var pointName in event.points) {
			Ti.API.info("Point " + pointName + " x=" + event.points[pointName].x
				+ ", y=" + event.points[pointName].y);
		}
		
		// You can use the above for the other events as well (touchmove, 
		// touchend, touchcancel). Note that event.points is not an array, 
		// so you should iterate it like the example above, and not as an array.
	});

	win.addEventListener("touchmove", function(event) {
		Ti.API.info("Touches moved, points: " + JSON.stringify(event.points));
	});
	
	win.addEventListener("touchend", function(event) {
		Ti.API.info("Touches ended, points: " + JSON.stringify(event.points));
	});
	
	win.addEventListener("touchcanceled", function(event) {
		Ti.API.info("Touches canceled, points: " + JSON.stringify(event.points));
	});

For an extended example, please check the provided app.js (under the example directory).

## Watch in action

The TiMultiTouch module is used in the Zampona iOS application. The application resembles a peruvian panflute and
uses the TiMultiTouch to enable playing two or more notes simultaneously. You can get it for free from [Zampona on iTunes](http://itunes.apple.com/us/app/zampona/id448009267?mt=8).


## Author

Copyright (C) 2011, 2012 Uri Shaked <uri@salsa4fun.co.il>.
Portions of the code are based on the original TiMultitouch module by masuidrive.

Homepage: [Uri Shaked](https://www.urish.org/).
Github page: [https://www.github.org/urish](https://www.github.org/urish).

## License

MIT License
