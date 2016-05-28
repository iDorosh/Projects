Titanium.UI.setBackgroundColor('#000');


//Main screen text and views.
var mainWindow = Ti.UI.createWindow({
	backgroundColor: "#000",
	fullscreen: true,
});

var backgroundImage = Ti.UI.createImageView({
	image: "images/background1.jpg",
});

var auto = Ti.UI.createLabel({
	text: "Auto",
	color: "#fff",
	top: 70,
	left: 31,
	font: {fontSize: 70, fontFamily: "Helvetica", fontWeight: "regular"},
});

var insider = Ti.UI.createLabel({
	text: "Insider",
	color: "#fff",
	top: 150,
	right: 33,
	font: {fontSize: 70, fontFamily: "Helvetica", fontWeight: "regular"},
});

var topCarsButton = Ti.UI.createView({
	top: 355,
	backgroundColor: "253971",
	borderRadius: 3,
	height: 60,
});

var carsBackground = Ti.UI.createView({
	top: 360,
	backgroundColor: "1d2c57",
	borderRadius: 3,
	height: 60,
});


var topCarsText = Ti.UI.createLabel({
	text: "Top Cars",
	color: "#fff",
	font: {fontSize: 42, fontFamily: "Helvetica", fontWeight: "regular"},
});

var find = Ti.UI.createView({
	top: 450,
	backgroundColor: "1c2a51",
	borderRadius: 3,
	width: 200,
	height: 45,
});

var findBackground = Ti.UI.createView({
	top: 450,
	backgroundColor: "101931",
	borderRadius: 3,
	width: 200,
	height: 50,
});


var findPageText = Ti.UI.createLabel({
	text: "Find A Dealer",
	color: "#fff",
	font: {fontSize: 24, fontFamily: "Helvetica", fontWeight: "regular"},
});

var mainWindowLabel = Ti.UI.createLabel({
	text: "1409 Ian Dorosh",
	color: "#fff",
	bottom: 20,
	font: {fontSize: 12, fontFamily: "Helvetica", fontWeight: "light"},
});


//Links json.js to app.js
var loadFile = require("json");


topCarsButton.add(topCarsText);
find.add(findPageText);
mainWindow.add(backgroundImage, auto, insider,carsBackground, topCarsButton, mainWindowLabel,findBackground, find);
mainWindow.open();





