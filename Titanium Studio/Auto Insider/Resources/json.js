//JSON Data
var data = {
	"info":{
		"cars": [
			{
				title: "Mazda 6", 
				overview: "One of the best deals out there the 2014 Mazda 6 provides drivers with a powerful ride while keeping it a comfortable one. Its speak body style, curved lines and LED taillights make it the perfect car for any young driver. The automatic climate control is great, the driver can simply pick a temperature and the car will automatically adjust the AC or heater to compensate for any rise or drop in temperature. The cars performance doesn't suffer because of its low price intact the 6’s Sky Active engine runs at a higher RPM then most cars in this price range allowing it to create 185 horse power making the car zoom.\n ", 			
				image: "mazda.jpg",
				specs: "30 City, 41 Highway\n185\n2.0L\n4\n280lb-ft\ni Sport, iTouring, GT",
				tech: "HD Radio\nLED Taillights\nAutomatic Climate Control\nBluetooth Handsfree",
				kbb: "9.4/10",
			
			},
			{
				title: "Honda Civic", 
				overview: "The 2014 Honda Civic is perfect for the college student who wants a fuel efficient car that still has the features of a more expensive one. The Civic comes with bluetooth handsfree technology allowing drivers to play their favorite from their phones without the hassle of dealing with cords. The bluetooth feature also allows you to keep your eyes on the road and hand on the steering wheel by letting you call and message your friends, family and coworkers all with your voice. The rear view camera is a great feature to have when backing up in a packed parking garage by allowing you to see what’s behind you.\n ", 
				image: "honda.jpg",
				specs: "30 City, 39 Highway\n143\n1.8L\n4\n129lb-ft\nLX, EX, HF, SI",
				kbb: "8.6/10" ,
				tech: "5in LCD Screen\nRearview Camera\nBluetooth Handsfree\nPandora Internet Radio",
			},
			{
				title: "Dodge Dart", 
				overview: "The 2014 Doge dart has a sporty racing body while being a fuel efficient and comfortable ride.  The dart has a best in class 8.4 inch navigation display, Being one of the largest on the market it makes it easy to locate specific buttons while cruising on the road. The dart also had a unique 7 inch gauge cluster separating it from the traditional mechanical gauges. The ability to customize the gauge is a great feature allowing users to see directions right next to their speed and gas levels without being to distracted. This car is perfect for those who want an aggressive look while keeping it at a great price and efficient.\n ", 
				image: "dodge.jpg",
				specs: "25 City, 36 Highway\n160\n2.0L\n4\n184lb-ft\nSE, SXT 2.4, SXT 2.1",
				kbb: "8.5/10",
				tech: "8.4in Display\n7in gauge cluster\nHandsfree\nPandora ",
			},
			{
				title: "Hyundai Elantra",
				overview: "The Elantra is the perfect car for a small family or college student. It provides a fuel efficient experience along with an affordable price.  The car has a 7 inch high-res navigation system making it easy to find the nearest gas station or mall. Music options never run out with bluetooth and usb connectivity, allowing the driver to connect their mobile phones and play their favorite songs. The Elantra has a sporty small frame that comes standard with 15 inch alloy wheels that can also be upgraded to 16 inch wheels. Full power accessories, usb interface and satellite radio also come standard with the Elantra.\n ",
				image: "elantra.jpg",
				specs: "28 City, 38 Highway\n145\n1.8L\n4\n130lb-ft\nSE, Base, Limited Sport",
				kbb: "7.9/10",
				tech: "7in High-Res Screen\nNavigation System\nUSB Audio Interface\nBluetooth Handsfree",
			},
			{
				title: "Kia Forte", 
				overview: "The KIA Forte comes with heated seats keeping them nice and warm in the winter months or cool in the hot summer days. Its power folding side mirrors close automatically when the car is put in park, giving you a peace of mind when parking in a busy road. The HID headlights provide long range illumination, But the coolest feature of the Kia Forte is its UVO eServices which allow users to look up directions on the computers and have those directions available to them once they sit in the car, removing the need to type up directions while driving keeping your trip safe.\n ", 
				image: "kia.jpg",
				specs: "25 City, 37 Highway\n148\n1.8L\n4\n168lb-ft\nLX, EX, SX",
				kbb: "9.0/10",
				tech: "Heated Seats\nPower Folding Side Mirrors\nHID Headlights\nUVO eServices",
			},
			{
				title: "Ford Fiesta", 
				overview: "The Ford Fiesta is for those who want to stay connected while on the road. On demand traffic reports is one of the best features for the driver, all you have to do is dictate an address and the Ford will find it and because it is always listening  there is no need for the driver to press any buttons before calling out the address. The Fiesta also has an onboard Pandora app allowing drivers to listen to their favorite artists and music although a smartphone can be connected with an existing Pandora account.\n ",
				image: "ford.jpg",
				specs: "28 City, 37 Highway\n120\n1.6L\n4\n202lb-ft\nST, SE, Fiesta S",
				kbb: "7.8/10",
				tech: "On Demand Traffic Report\nSports, Movie Information\nPandora Internet Radio, Bluetooth Handsfree",
			},
			{
				title: "Chevy Spark", 
				overview: "The Chevy spark is a small compact car that is loaded with cool tech features. Drivers can easily use the OnStar to locate a coffee shop or get roadside assistance in an emergency. With onboard LTE you'll have the Internet at your fingers tips with your smartphone, tablet, or laptop using the Wi-Fi hotspot feature. Siri Eyes free is also included in the car allowing you to make call or compose text messages without taking your eyes off the road.  This car gives the best tech features in a small low priced package that is fuel efficient and easy to maintain.\n ", 
				image: "chevy.jpg",
				specs: "31 City, 39 Highway\n84\n1.2L\n4\n83lb-ft\nLS, 1LT, 2LT",
				kbb: "8.6/10",
				tech: "OnStar\n4G LTE\nWifi Hotspot\nBluetooth Handsfree",
			},
		]
	}
};


//Extra JSON Data
var data2 = {
	"info":{
		"dealers": [
			{
				title: "Auto Best", 
				distance: "10 Minutes From Current Location", 	
				phone: "(123)-456-7899"		
			},
			{
				title: "Auto Insider", 
				distance: "25 Minutes From Current Location", 	
				phone: "(123)-456-7898"		
			},
			{
				title: "Luxury and Exotics", 
				distance: "30 Minutes From Current Location", 	
				phone: "(123)-456-7897"	,	
			},
			{
				title: "Best Dealership", 
				distance: "40 Minutes From Current Location", 	
				phone: "(123)-456-7896"	,	
			},
			{
				title: " Fast Cars", 
				distance: "40 Minutes From Current Location", 	
				phone: "(123)-456-7896"	,	
			},
		]
	}
};

// Variables
var autoBest = data2.info.dealers[0].title;
var autoBestPhone = data2.info.dealers[0].phone;
var autoInsider = data2.info.dealers[1].title;
var autoInsiderPhone = data2.info.dealers[1].phone;
var luxury = data2.info.dealers[2].title;
var luxuryPhone = data2.info.dealers[2].phone;
var best = data2.info.dealers[3].title;
var bestPhone = data2.info.dealers[3].phone;
var fast = data2.info.dealers[4].title;
var fastPhone = data2.info.dealers[4].phone;

//Top cars Window
var win = Ti.UI.createWindow({
  backgroundColor: "#efefef",
  fullscreen: true,
  
});

//Enables scrolling for the list of cars
var scrollView = Ti.UI.createScrollView({
  contentWidth: "auto",
  contentHeight: "auto",
  showVerticalScrollIndicator: true,
  showHorizontalScrollIndicator: false,
  top: 265,
  height: "auto",
  width: "auto"
});


//Top 7 Cars Labels
var view = Ti.UI.createView({
  backgroundColor:"#efefef",
  top: 5,
  height: 835,
  width: "100%",
});

var topLabel = Ti.UI.createLabel({
	text: "Top",
	color: "#2d7595",
	top: 30,
	left: 80,
	font: {fontSize: 52, fontFamily: "Helvetica", fontWeight: "light"},
});

var sevenLabel = Ti.UI.createLabel({
	text: "7",
	color: "#1c2a51",
	top: 5,
	right: 80,
	font: {fontSize: 110, fontFamily: "Helvetica", fontWeight: "light"},
});

var carsLabel = Ti.UI.createLabel({
	text: "Cars",
	color: "#66afac",
	top: 75,
	font: {fontSize: 110, fontFamily: "Helvetica", fontWeight: "light"},
});

var ofLabel = Ti.UI.createLabel({
	text: "of",
	color: "#535353",
	top: 200,
	left: 85,
	font: {fontSize: 30, fontFamily: "Helvetica", fontWeight: "light"},
});

var fourteenLabel = Ti.UI.createLabel({
	text: "2014",
	color: "#28466d",
	top: 185,
	right: 80,
	font: {fontSize: 52, fontFamily: "Helvetica", fontWeight: "light"},
});



//Back Button and navigation bar
var backLabel = Ti.UI.createLabel({
	text: "Back",
	color: "#1c2a51",
	top: 2,
	left: 10,
	font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "light"},
});

var navBar1 = Ti.UI.createView({
		backgroundColor:"#efefef",
		top: 0, 
		height: 30,
	});





// Cars Button Views and Labels with JSON Data
var mazdaButton = Ti.UI.createView({
  backgroundColor:"#66afad",
  top: 0,
  height: 80,
  width: "100%",
  image: "images/" + data.info.cars[0].image,
  desc: data.info.cars[0].overview,
  title: data.info.cars[0].title,
  specs: data.info.cars[0].specs,
  kbb: data.info.cars[0].kbb,
  tech: data.info.cars[0].tech,
});

var mazdaLabel = Ti.UI.createLabel({
	text: data.info.cars[0].title,
	color: "#ffff",
	left: 20,
	font: {fontSize: 40, fontFamily: "Helvetica", fontWeight: "light"},
	image: "images/" + data.info.cars[0].image,
  	desc: data.info.cars[0].overview,
  	title: data.info.cars[0].title,
  	specs: data.info.cars[0].specs,
  	kbb: data.info.cars[0].kbb,
  	tech: data.info.cars[0].tech,
});

var hondaButton = Ti.UI.createView({
  backgroundColor:"#347998",
  top: 80,
  height: 80,
  width: "100%",
  image: "images/" + data.info.cars[1].image,
  desc: data.info.cars[1].overview,
  title: data.info.cars[1].title,
  specs: data.info.cars[1].specs,
  kbb: data.info.cars[1].kbb,
  tech: data.info.cars[1].tech,
});

var hondaLabel = Ti.UI.createLabel({
	text: data.info.cars[1].title,
	color: "#ffff",
	left: 20,
	font: {fontSize: 40, fontFamily: "Helvetica", fontWeight: "light"},
	image: "images/" + data.info.cars[1].image,
	desc: data.info.cars[1].overview,
	title: data.info.cars[1].title,
	specs: data.info.cars[1].specs,
	kbb: data.info.cars[1].kbb,
	tech: data.info.cars[1].tech,
});

var dodgeButton = Ti.UI.createView({
  backgroundColor:"#236785",
  top: 160,
  height: 80,
  width: "100%",
  image: "images/" + data.info.cars[2].image,
  desc: data.info.cars[2].overview,
  title: data.info.cars[2].title,
  specs: data.info.cars[2].specs,
  kbb: data.info.cars[2].kbb,
  tech: data.info.cars[2].tech,
});

var dodgeLabel = Ti.UI.createLabel({
	text: data.info.cars[2].title,
	color: "#ffff",
	left: 20,
	font: {fontSize: 40, fontFamily: "Helvetica", fontWeight: "light"},
	image: "images/" + data.info.cars[2].image,
  	desc: data.info.cars[2].overview,
  	title: data.info.cars[2].title,
  	specs: data.info.cars[2].specs,
  	kbb: data.info.cars[2].kbb,
  	tech: data.info.cars[2].tech,
});

var hyundaiButton = Ti.UI.createView({
  backgroundColor:"#305b7f",
  top: 240,
  height: 80,
  width: "100%",
  image: "images/" + data.info.cars[3].image,
  desc: data.info.cars[3].overview,
  title: data.info.cars[3].title,
  specs: data.info.cars[3].specs,
  kbb: data.info.cars[3].kbb,
  tech: data.info.cars[3].tech,
});

var hyundaiLabel = Ti.UI.createLabel({
	text: data.info.cars[3].title,
	color: "#ffff",
	left: 20,
	font: {fontSize: 40, fontFamily: "Helvetica", fontWeight: "light"},
	image: "images/" + data.info.cars[3].image,
  	desc: data.info.cars[3].overview,
  	title: data.info.cars[3].title,
  	specs: data.info.cars[3].specs,
  	kbb: data.info.cars[3].kbb,
  	tech: data.info.cars[3].tech,
});

var kiaButton = Ti.UI.createView({
  backgroundColor:"#2d4970",
  top: 320,
  height: 80,
  width: "100%",
  image: "images/" + data.info.cars[4].image,
  desc: data.info.cars[4].overview,
  title: data.info.cars[4].title,
  specs: data.info.cars[4].specs,
  kbb: data.info.cars[4].kbb,
  tech: data.info.cars[4].tech,
});

var kiaLabel = Ti.UI.createLabel({
	text: data.info.cars[4].title,
	color: "#ffff",
	left: 20,
	font: {fontSize: 40, fontFamily: "Helvetica", fontWeight: "light"},
	image: "images/" + data.info.cars[4].image,
  	desc: data.info.cars[4].overview,
  	title: data.info.cars[4].title,
  	specs: data.info.cars[4].specs,
  	kbb: data.info.cars[4].kbb,
  	tech: data.info.cars[4].tech,
});

var fordButton = Ti.UI.createView({
  backgroundColor:"#193d51",
  top: 400,
  height: 80,
  width: "100%",
  image: "images/" + data.info.cars[5].image,
  desc: data.info.cars[5].overview,
  title: data.info.cars[5].title,
  specs: data.info.cars[5].specs,
  kbb: data.info.cars[5].kbb,
  tech: data.info.cars[5].tech,
});

var fordLabel = Ti.UI.createLabel({
	text: data.info.cars[5].title,
	color: "#ffff",
	left: 20,
	font: {fontSize: 40, fontFamily: "Helvetica", fontWeight: "light"},
	image: "images/" + data.info.cars[5].image,
 	desc: data.info.cars[5].overview,
  	title: data.info.cars[5].title,
  	specs: data.info.cars[5].specs,
  	kbb: data.info.cars[5].kbb,
  	tech: data.info.cars[5].tech,
});

var chevyButton = Ti.UI.createView({
  backgroundColor:"#1c2a51",
  top: 480,
  height: 80,
  width: "100%",
  image: "images/" + data.info.cars[6].image,
  desc: data.info.cars[6].overview,
  title: data.info.cars[6].title,
  specs: data.info.cars[6].specs,
  kbb: data.info.cars[6].kbb,
  tech: data.info.cars[6].tech,
});

var chevyLabel = Ti.UI.createLabel({
	text: data.info.cars[6].title,
	color: "#ffff",
	left: 20,
	font: {fontSize: 40, fontFamily: "Helvetica", fontWeight: "light"},
	image: "images/" + data.info.cars[6].image,
  	desc: data.info.cars[6].overview,
  	title: data.info.cars[6].title,
  	specs: data.info.cars[6].specs,
  	kbb: data.info.cars[6].kbb,
  	tech: data.info.cars[6].tech,
});	

//Detail Window Function
var detail = function(data){
	
	// Detail Window
	var detailWindow = Ti.UI.createWindow({
		title: data.title,
		backgroundColor: "#efefef",
		fullscreen: true,
	});
	
	//Enables scrolling in Detail window
	var detailScrollView = Ti.UI.createScrollView({
		contentWidth: "auto",
		contentHeight: "auto",
		showVerticalScrollIndicator: true,
		showHorizontalScrollIndicator: false,
		height: "100%",
	    width: "100%"
	});
	
	//Car Image
	var cars = Ti.UI.createImageView({
		top: 0,		
		image: data.image,
	});
	
	
	
	//BackButton, Home Button and Navigation Button
	var backLabel1 = Ti.UI.createLabel({
		text: "Back",
		color: "#efefef",
		top: 2,
		left: 10,
		font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "light"},
	});

	var home = Ti.UI.createLabel({
		text: "Home",
		color: "#347998",
		top: 2,
		right: 10,
		font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "light"},
	});
	
	var navBar2 = Ti.UI.createView({
		backgroundColor:"#000",
		top: 0, 
		height: 30,
	});
	


	//Detail Labels and views
	var detailText = Ti.UI.createLabel({
		text: data.desc,
		top: 640,
		left: 15,
		right: 15,
		font: {fontSize: 18, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#1f1f1f",
	});
	
	var specs = Ti.UI.createLabel({
		text: "Specs",
		font: {fontSize: 22, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#28466d",
		left: 35,
		top:  250,
	});
	
	var specsLabel = Ti.UI.createLabel({
		text: "MPG\nHP\nEngine\nCylinders\nTorque\nTrims",
		font: {fontSize: 18, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#66afac",
		left: 23,
		top:  specs.top + 30,
		textAlign: Ti.UI.TEXT_ALIGNMENT_RIGHT,
	});
	
	var actualSpecs = Ti.UI.createLabel({
		text: data.specs,
		font: {fontSize: 18, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#1f1f1f",
		left: 117,
		top:  specs.top + 30,
		textAlign: Ti.UI.TEXT_ALIGNMENT_LEFT,
	});
	
	
	var techSpecs = Ti.UI.createLabel({
		text: "Tech Specs",
		font: {fontSize: 22, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#28466d",
		left: 55,
		top:  440,
	});
	
	var actualTechSpecs = Ti.UI.createLabel({
		text: data.tech,
		font: {fontSize: 18, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#1f1f1f",
		left: 55,
		top:  techSpecs.top + 30,
	});
	
	var line1 = Ti.UI.createView({
	  backgroundColor:"#939393",
	  top: techSpecs.top - 16,
	  height: 1,
	  width: "60%",
	});
	
		
	var kbb = Ti.UI.createLabel({
		text: "Kelly Blue Book Review",
		font: {fontSize: 16, fontFamily: "Helvetica", fontWeight: "light"},
		color: "66afac",
		left: 13,
		top: detailText.top - 25,
	});
	
	var kbbRating = Ti.UI.createLabel({
		text: data.kbb,
		font: {fontSize: 18, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#28466d",
		right: 80,
		top: detailText.top - 26,
	});
	
	var overView = Ti.UI.createLabel({
		text: "Overview",
		font: {fontSize: 22, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#28466d",
		left: 11,
		top: kbb.top - 25,
	});
	
	var line2 = Ti.UI.createView({
	  backgroundColor:"#939393",
	  top: overView.top - 16,
	  height: 1,
	  width: "60%",
	});
	
	
	var carName = Ti.UI.createView({
		backgroundColor:"#305b7f",
		bottom: 0, 
		height: 40,
		opacity: .8,
	});
	
	var carNameLabel = Ti.UI.createLabel({
		text: "2014 " + data.title ,
		left: 20,
		font: {fontSize: 26, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#fff",
	});
	
	
	//Event Listener to go back to list of cars
	backLabel1.addEventListener("click", function(openData){
	detailWindow.close({
		transition: Ti.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
	});
});

	//Event Listener to go back Home
	home.addEventListener("click", function(openData){
	detailWindow.close({
		transition: Ti.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
	});
	win.close();
});

	carName.add(carNameLabel);
	cars.add(carName);
	detailScrollView.add(cars,detailText, overView, kbb, specs,kbbRating, specsLabel, actualSpecs, techSpecs, actualTechSpecs, line1, line2);
	detailWindow.add(detailScrollView, navBar2, backLabel1, home);
	detailWindow.open({ transition: Ti.UI.iPhone.AnimationStyle.FLIP_FROM_RIGHT});
};


//Event Propagation for the scroll view in top 7 list
scrollView.addEventListener("click", function(event){
	detail(event.source);
});

//Event Listener for back button to go from the top list, home
backLabel.addEventListener("click", function(openData){
	win.close({
		transition: Ti.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
	});
});

//Event Listener to go into top 7 list
topCarsButton.addEventListener("click", function(openData){
	win.open({
		transition: Ti.UI.iPhone.AnimationStyle.FLIP_FROM_RIGHT
	});
});


chevyButton.add(chevyLabel);
fordButton.add(fordLabel);
kiaButton.add(kiaLabel);
hyundaiButton.add(hyundaiLabel);
dodgeButton.add(dodgeLabel);
hondaButton.add(hondaLabel);
mazdaButton.add(mazdaLabel);
view.add(topLabel, sevenLabel, carsLabel, ofLabel, fourteenLabel);
scrollView.add(mazdaButton, hondaButton, dodgeButton, hyundaiButton, kiaButton, fordButton, chevyButton);
win.add(view, scrollView, navBar1, backLabel);


//Gets users current location
var currentLocation = function(){
	//Asks user for permission to get current location and also tells the user why it is needed.
	Ti.Geolocation.purpose = "To Find A Dealer Near You";
	Titanium.Geolocation.getCurrentPosition( function(e) {
	    if (!e.success) {
	        alert('Could not retrieve location');
	        return;
	    };
	    var longitude = e.coords.longitude;
	    var latitude = e.coords.latitude;
	
	// Gets the users current city
	Titanium.Geolocation.reverseGeocoder(latitude,longitude, function(evt) {
	        var city;
	        
	        if (evt.success) {
	            var places = evt.places;
	            if (places && places.length) {
	                city = places[0].city;
	                
	                   	//This alert takes the city and puts it into the alert box along with a list of dealerships from the JSON data;
	                    var alert = Titanium.UI.createAlertDialog({
					    title:"Dealers Near "+ city,
					    message:autoBest+" "+autoBestPhone+"\n"+ autoInsider+" "+autoInsiderPhone+"\n"+luxury+" "+luxuryPhone+"\n"+ best+" "+bestPhone+"\n"+fast+" "+fastPhone,
					
					});
						alert.show();
	            } else {
	                address = "No address found";
		            };
		        };
		      
		    });
		});
};

//Event Listener 
find.addEventListener("click", function(openData){
		currentLocation();
});
