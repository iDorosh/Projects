
//If there is a network This function will run
var  userInterface = function(forecast, data){
	//all very similar until line 274
	var rowData = [];
	i = forecast.length - 1;
	var a = forecast[i].temp;
	var c = a;
	var b = Math.round(c);
	
	var win = Ti.UI.createWindow({
		title: "Weather Insider",
		backgroundColor: "E0E0E2",
		layout: "vertical",
		navBarHidden: true,
	});
		
	var scroll = Ti.UI.createScrollView({
		top: 20,
		contentWidth: "100%",		
		showVerticalScrollIndicator: false,
		layout: "vertical",
		width: "100%",
		height: "auto",
	});
		
       
		
	var city = Titanium.UI.createLabel({
		text: forecast[i].city,
		top: -20,
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
		top: "2%",
		height: "33%",
		image: "weathericons/cloudy.png"
	});
		
	var line = Ti.UI.createView({
		top:5,
		width: "60%",
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
		font: {fontSize: "25%", fontFamily: "Helvetica", fontWeight: "light"}
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
		
	var arrow = Ti.UI.createImageView({
		top: "1%",
		height: "3%",
		image: "image/arrow.png"
	});
		
	var topSpace = Ti.UI.createView({
		top: 0,
		width: "90%",
		height: "2%",
	});
			
	var topSpace2 = Ti.UI.createView({
		top: 0,
		width: "90%",
		height: 70,
	});
			
	var refresh = Ti.UI.createImageView({
		height: "3%",
		right: -75,
		top:5,
		image: "image/refresh.png"
	});
			
	if (Ti.Platform.osname == "ipad"){
		refresh.right = -60;
	};
	refresh.addEventListener("click",function(e){
		net.currentLocation();
	});	
		
	updateView.add(lastUpDate);
	scroll.add(refresh, city,state, icon,temp, weather, updateView, line, tenDay,arrow,topSpace);
	rowData.push(scroll);
		
		//for loop for my houly forcast	
		for(var i=0, j=data.length; i<10; i++){
			
		
			var lines = Ti.UI.createView({
					top: 10,
					width: "90%",
					height: "10%",
					borderRadius: 15,
					backgroundColor:"#c2c5c7",
				});
				
			var lines1 = Ti.UI.createImageView({
					image: "weathericons/sun.png",
					
					height: "65%",
				});
				
			var test = Titanium.UI.createLabel({
				text: data[i].FCTTIME.civil,
				top:"20%",
				left: "5%",
				color:"#fff",
				font: {fontSize: "18%", fontFamily: "Helvetica", fontWeight: "regular"},
				
			});
			
			var degrees = Titanium.UI.createLabel({
				text: data[i].temp.english+ "°F",
				right: "5%",
				color:"#0f70b8",
				font: {fontSize: "20%", fontFamily: "Helvetica", fontWeight: "regular"}
			});
			
			var test1 = Titanium.UI.createLabel({
				text: data[i].FCTTIME.weekday_name,
				top: '50%',
				left: "6%",
				color:"103855",
				font: {fontSize: "14%", fontFamily: "Helvetica", fontWeight: "light"}
			});
			
			//custom ipad properties
			if (Ti.Platform.osname == "ipad"){
				test.font = {fontSize: 36};
				test.top = "20%",
				test1.font = {fontSize: 24};
				test1.top = "54%";
				degrees.font = {fontSize: 36};
				lines1.height = 80;
			};
			
			//puts custom icons for hourly forcast
			if (data[i].condition === "Clear"){
				lines1.image = "weathericons/sun.png";
			};	
			if (data[i].condition === "Mostly Cloudy"){
				lines1.image = "weathericons/cloudy.png";
			};
			if (data[i].condition === "Overcast"){
				lines1.image = "weathericons/overcast.png";
			};
			if (data[i].condition === "Rain"){
				lines1.image = "weathericons/ran.png";
			};
			
			lines.add(lines1,test, test1,degrees);
			scroll.add(lines);
		};
		
	//updates time		
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
		updateTime(Ti.App.Properties.getString('timestamp'));
		
		if (forecast.weather === "Overcast"){
			icon.image = "weathericons/overcast.png";
		};
		if (forecast.weather === "Clear"){
			icon.image = "weathericons/sun.png";
		};
		if (forecast.weather === "Partly Cloudy"){
			icon.image = "weathericons/cloudy.png";
		};
		
		var navWindow = Ti.UI.iOS.createNavigationWindow({
		window: win,
	});
		scroll.add(topSpace2);
		win.add(rowData);
		navWindow.open();
};



//exports user interface functions to be called in data.js
exports.userInterface = userInterface;






