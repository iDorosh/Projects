//if there is no network this function will run;
var userInterface2 = function(forecast,data){
	//Variables to round the temp
	var i = forecast.length - 1;
	var a = forecast[i].temp;
	var c = a;
	var b = Math.round(c);
	
	//views and labels	
	var win = Ti.UI.createWindow({
		title: "Weather Insider",
		backgroundColor: "E0E0E2",
		layout: "vertical",
		navBarHidden: true,
	});
	
	var city = Titanium.UI.createLabel({
			text: forecast[i].city,
			top:0,
			color:"#073f68",
			font: {fontSize: "40%", fontFamily: "Helvetica", fontWeight: "Bold"}
		});
		
		var state = Titanium.UI.createLabel({
			text: forecast[i].state,
			top: 1,
			color:"1288e0",
			font: {fontSize: "20%", fontFamily: "Helvetica", fontWeight: "light"}
		});
		
		var icon = Ti.UI.createImageView({
			top: "3%",
			height: "33%",
			image: "weathericons/cloudy.png"
		});
		
	
		var line = Ti.UI.createView({
			top:5,
			width: 305,
			height: 1,
			backgroundColor:"#2D2D2D",
		});
		var weather = Titanium.UI.createLabel({
			text: forecast[i].condition,
			top: ".5%",
			color:"#073f68",
			font: {fontSize: "20%", fontFamily: "Helvetica", fontWeight: "bold"}
		});
		
		var temp = Titanium.UI.createLabel({
			text: b+"°F",
			top: "3%",
			color:"878787",
			font: {fontSize: "50%", fontFamily: "Helvetica", fontWeight: "bold"}
		});

		
		var tenDay = Titanium.UI.createLabel({
			text: "Hourly Forecast",
			top: "1.5%",
			color:"#2D2D2D",
			font: {fontSize: "30%", fontFamily: "Helvetica", fontWeight: "light"}
		});
	
		
		var updateView = Ti.UI.createView({
				top: 30,
				width: "90%",
				height: 20,
				
			});
			
		
		var lastUpDate = Titanium.UI.createLabel({
			text: "Last Updated",
			left: 65,
			color:"#878787",
			font: {fontSize: "14%", fontFamily: "Helvetica", fontWeight: "regular"}
		});
		
		var unavailable = Titanium.UI.createLabel({
			text: "Unavailable",
			top: 10,
			color:"1288e0",
			font: {fontSize: "20%", fontFamily: "Helvetica", fontWeight: "light"}
		});
		
		var refresh = Ti.UI.createImageView({
			height: "3%",
			top: 30,
			right: -100,
			image: "image/refresh.png"
		});
		
		//displayes refresh time
		var updateTime = function(data){
			var time = Titanium.UI.createLabel({
				text: data,
				right: 65,
				color:"#0f70b8",
				font: {fontSize: "20%", fontFamily: "Helvetica", fontWeight: "regular"}
			});
				if (Ti.Platform.osname == "ipad"){
					lastUpDate.left = 265;
					time.right = 265;
				};
			updateView.add(time);
		};	
		
		//custom properties for ipad
		if (Ti.Platform.osname == "ipad"){
				refresh.right = -135;	
				city.top = 140;	
			};
			
		//changes icons based on weather conditons
		if (forecast.weather === "Overcast"){
		icon.image = "weathericons/overcast.png";
		};
		if (forecast.weather === "Clear"){
			icon.image = "weathericons/sun.png";
		};
		if (forecast.weather === "Partly Cloudy"){
			icon.image = "weathericons/cloudy.png";
		};
		
		refresh.addEventListener("click",function(e){
			net.currentLocation();
		});	
		
		//opens nav window
		var navWindow = Ti.UI.iOS.createNavigationWindow({
			window: win,
		});
	
		updateTime(Ti.App.Properties.getString('timestamp'));
		updateView.add(lastUpDate,refresh);
		win.add(refresh,city,state, icon,temp, weather, updateView, line, tenDay,unavailable);
		navWindow.open();
};

exports.userInterface2 = userInterface2;