Titanium.UI.setBackgroundColor("#000");

var mainWindow = Ti.UI.createWindow({
	backgroundColor: "#6c6c6c",
	title: "Cars"
});

var cars = Ti.UI.createTableView({
});

var navWindow = Ti.UI.iOS.createNavigationWindow({
	window: mainWindow,
});

var loadFile = require("cars");

mainWindow.add(cars);
navWindow.open();