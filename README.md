Multitouch module for Appcelerator Titanium (iPhone & iOS)
===========================================

Handle multi touch events inside your iOS applications.

INSTALL
--------------

If your Titanium SDK is installed in /Library/Application Support/Titanium:

	./build.py && rm -Rf /Library/Application\ Support/Titanium/modules/iphone/org.urish.titanium.multitouch/ && unzip org.urish.titanium.multitouch-iphone-1.0.zip -d /Library/Application\ Support/Titanium/

If your Titanium SDK is installed under your home directory:

	./build.py && rm -Rf ~/Library/Application\ Support/Titanium/modules/iphone/org.urish.titanium.multitouch/ && unzip org.urish.titanium.multitouch-iphone-1.0.zip -d ~/Library/Application\ Support/Titanium/

If you have another Titanium Mobile SDK version, please change the value of the "TITANIUM_SDK_VERSION" property in titanium.xcconfig to match your installed version.

PRECOMPILED VERSION
--------------
If you would rather not compile the module yourself, you can simply download a precompiled version.
Precompiled versions are available here:

[Precompiled version of the TiMultitouch module](https://github.com/urish/TiMultitouch/blob/master/dist)

HOW TO USE IT
-------------
1. Add the multitouch module to your tiapp.xml: inside the `<modules>` tag add the following line:
	`<module version="1.0">org.urish.titanium.multitouch</module>`
2. Add the following code in the beginning of your app.js:
	`require("org.urish.titanium.multitouch");`
3. To enable multitouch for a window or a view, add an empty event listener to the 'singletap' event 
	(see example below).
4. Now your touchstart/touchmove/touchend/touchcancel events will contain a new field: "points". 
	This field is a dictionary with information about the active touches: the key is the id of the touch, 
	and the value is an object with the following properties: 'x', 'y' and 'globalPoint'.

WATCH IN ACTION
--------------
The TiMultiTouch module is used in the Zampoña iOS application. The application resembles a peruvian panflute and
uses the TiMultiTouch to enable playing two or more notes simultaneously. You can get it for free from [Zampona on iTunes].

CODE EXAMPLE
--------------

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

For more info, please check [app.js](https://github.com/urish/TiMultitouch/blob/master/example/app.js)


LICENSE
--------------
MIT License


COPYRIGHT
--------------
* 2011 Uri Shaked ([urish](https://github.com/urish))
* 2011 Jose Fernandez (magec) github.com/magec (small change and tested in 1.6.2)
* 2010 Yuchiro MASUI (masuidrive) <masui@masuidrive.jp>

  [Zampona on iTunes]: http://itunes.apple.com/us/app/zampona/id448009267?mt=8
