// Login Information

//Username: iDorosh
//Password: Doroshi

//Username: JMiller
//Password: Miller132 			

//Username: AJohnson
//Password: AliJ 		

//Username: AlexDorosh
//Password: doroalex 		
			
//Username: LJefferson
//Password: jefferson132 	




// this sets the background color of the master UIView (when there are no windows/tab groups on it)
Titanium.UI.setBackgroundColor('#000');


// simple home screen with login and view trips buttons
var mainWindow = Ti.UI.createWindow({
	backgroundColor: "#efefef",
	fullscreen: true,
	navBarHidden: true,
});

var viewTrips = Ti.UI.createLabel({
	top: 400,
	text: "View Trips",
	color: "94bc5b",
	font: {fontSize: 34, fontFamily: "Helvetica", fontWeight: "Lite"},
});

var logInButtonHome = Ti.UI.createLabel({
	bottom: 25,
	text: "Login",
	color: "94bc5b",
	font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "Lite"},
});

var info = Ti.UI.createLabel({
	top: 10,
	text: "Ian Dorosh 1409",
	color: "94bc5b",
	font: {fontSize: 14, fontFamily: "Helvetica", fontWeight: "Lite"},
});

var tripifyHome = Ti.UI.createLabel({
	top: 130,
	text: "Tripify",
	color: "#94bc5b",
	font: {fontSize: 80, fontFamily: "Helvetica", fontWeight: "bold"},
});

var bar = Ti.UI.createView({
	bottom: 70,
	backgroundColor: "#94bc5b",
	height: 1,
	width: "240",
	});

mainWindow.add(logInButtonHome,tripifyHome, viewTrips, info, bar); 

//creates a navigation window and puts the main window inside 
var navWindow = Ti.UI.iOS.createNavigationWindow({
	window: mainWindow,
});

//loads up json information
var loadFile = require("json");