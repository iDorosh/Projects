Titanium.UI.setBackgroundColor('#000');

var mainWindow = Ti.UI.createWindow({
	title: "My First App",
	backgroundColor: "#fff",
});

var mainView = Ti.UI.createView({
	backgroundColor: "#333",
	borderRadius:2,
	borderWidth: 1,
	top: 50,
	left: 20,
	right : 20,
	bottom : 100
});


var behindMainView = Ti.UI.createView({
	backgroundColor: "#00259d",
	borderRadius:2,
	borderWidth: 1,
	borderColor: "00259d",
	top: 60,
	left: 10,
	right : 10,
	bottom : 110
});


var previousButton = Ti.UI.createView({
	backgroundColor: "#00259d",
	borderRadius: 4,
	borderWidth: 1,
	width: 130,
	height: 50,
	left: 20,
	bottom: 25,
});

var nextButton = Ti.UI.createView({
	backgroundColor: "#00259d",
	borderRadius: 4,
	borderWidth: 1,
	width: 130,
	height: 50,
	right: 20,
	bottom: 25,
});

var previousButtonText = Ti.UI.createLabel({
	text: "Previous",
	color: "#fff",
	font: {fontSize: 24, fontFamily: "Helvetica", fontWeight: "regular"}
});

var nextButtonText = Ti.UI.createLabel({
	text: "Next",
	color: "#fff",
	font: {fontSize: 24, fontFamily: "Helvetica", fontWeight: "regular"}
});

var mainText = Ti.UI.createLabel({
	text: "Top Ten Cars",
	color: "#fff",
	font: {fontSize: 24, fontFamily: "Helvetica", fontWeight: "regular"}
});

var loadFile= require("cars");

mainWindow.add(behindMainView, mainView, previousButton, nextButton);
previousButton.add(previousButtonText); 
nextButton.add(nextButtonText);
mainView.add(mainText);
mainWindow.open();
  