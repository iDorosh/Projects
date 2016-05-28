Titanium.UI.setBackgroundColor('#000');



var mainWindow = Ti.UI.createWindow({
	title: "Cars",
	backgroundColor: "#3d3d3e",
	fullscreen: true,
});


var galleryButton = Ti.UI.createView({
	top:0,
	backgroundColor: "#128dff",
	height: 100,
});


var galleryText = Ti.UI.createLabel({
	text: "Show Room",
	color: "#fff",
	left: 30,
	font: {fontSize: 24, fontFamily: "Helvetica", fontWeight: "regular"},
});


var dataPageButton = Ti.UI.createView({
	top: galleryButton.top+galleryButton.height,
	backgroundColor: "0b5fad",
	height: 100,
});


var dataPageText = Ti.UI.createLabel({
	text: "Specs",
	color: "#fff",
	left: 30,
	font: {fontSize: 24, fontFamily: "Helvetica", fontWeight: "regular"},
});


var customizeButton = Ti.UI.createView({
	top: dataPageButton.top+dataPageButton.height,
	backgroundColor: "#0c4375",
	height: 100,
});

var customizeButtonText = Ti.UI.createLabel({
	text: "Order",
	color: "#fff",
	left: 30,
	font: {fontSize: 24, fontFamily: "Helvetica", fontWeight: "regular"},
});


var mainWindowLabel = Ti.UI.createLabel({
	text: "1407 Ian Dorosh",
	color: "#fff",
	bottom: 20,
	font: {fontSize: 12, fontFamily: "Helvetica", fontWeight: "light"},
});

var openGallery = function(){	
	var galleryView = Ti.UI.createWindow({
		title: "Show Room",
		backgroundColor: "#fff",
		fullscreen: true,
		url: "carGallery.js"
	});
	navWindow.openWindow(galleryView);
};

var openSettings = function(){
	customizeView = Ti.UI.createWindow({
		title: "Customize",
		backgroundColor: "fff",
		fullscreen: true,
		url: "order.js",
	});
	navWindow.openWindow(customizeView);
};

dataPageButton.addEventListener("click", function(openData){
	navWindow.openWindow(dataView);
});

galleryButton.addEventListener("click", openGallery);
customizeButton.addEventListener("click", openSettings);

var navWindow = Ti.UI.iOS.createNavigationWindow({
	window: mainWindow,
});

var loadFile = require("cars");

customizeButton.add(customizeButtonText);
dataPageButton.add(dataPageText);
galleryButton.add(galleryText);
mainWindow.add(galleryButton, dataPageButton, customizeButton, mainWindowLabel);
navWindow.open();





