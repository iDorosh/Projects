Titanium.UI.setBackgroundColor('#000');


var galleryView = Ti.UI.createWindow({
	title: "Gallery",
	backgroundColor: "#fff",
	layout : "horizontal",
});

var mainWindow = Ti.UI.createWindow({
	title: "My Photos",
	backgroundColor: "#fff",
});

var openGalleryButton = Ti.UI.createView({
	backgroundColor: "000",
	opacity: .5,
	height: 60,
	width: 200,	
	borderRadius: 5,
	
});

var openGalleryText = Ti.UI.createLabel({
	text: "Open Gallery",
	color: "#fff",
});

openGalleryButton.addEventListener("click", function(open){
	navWindow.openWindow(galleryView);
});


var navWindow = Ti.UI.iOS.createNavigationWindow({
	window: mainWindow,
});

var loadFile = require("gallery");


openGalleryButton.add(openGalleryText);
mainWindow.add(openGalleryButton);

navWindow.open();

 