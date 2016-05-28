
//Requires the ui.js file to run
var ui = require("ui");
var ui2 = require("ui2");
var jsonData2 = [];
var test = true;

//Function to check network status
var netCheck = function(longitude,latitude){
	
var ui = require("ui");
var url = "http://api.wunderground.com/api/035012bdcd3a3f65/conditions/q/"+latitude+","+longitude+".json";
	if (Ti.Network.online) {
	     var getData = Ti.Network.createHTTPClient();
	     getData.onload = function(e){
	          var json = JSON.parse(this.responseText);
	          var forecast = json.current_observation;
	          var city = forecast.display_location.city;
	          var state = forecast.display_location.state_name;
	          var temp = forecast.temp_f;
	          var condition = forecast.weather;
	          var timestamp = function(){
	    	 		var hours = Math.round(new Date().getHours());
	    	 		var min = Math.round(new Date().getMinutes());
		    	 		
		    	 		if(hours>12){
		    	 			var hours = hours-12;
		    	 			var min = min+"pm";
		    	 		}else{
		    	 			var hours = hours;
		    	 			var min = min+"am";
		    	 		};
		    	 		
		    	 		if(min<10){
			    	 		return hours+":"+"0"+min;
			    	 		}else {
			    	 			return hours+":"+min;
			    	 		};
		    	};
		    	
				test = true;
				Ti.App.Properties.setString('timestamp', timestamp());
				create(city,state,condition,temp);
				read();
		 }; //getData.onload closing
	     getData.open("GET", url);
	     getData.send();
	} else {
	     alert("Network currently unavailable.");
	     test=false;
	     read();
		}; // if else Ti.Network closing
};
//exports netCheck function to app.js were it can be called.
exports.netCheck = netCheck;

var netCheck2 = function(longitude, latitude){
	var ui = require("ui");
	var url = "http://api.wunderground.com/api/035012bdcd3a3f65/hourly/q/"+latitude+","+longitude+".json";
		if (Ti.Network.online) {
		     var getData = Ti.Network.createHTTPClient();
		     getData.onload = function(e){
		          var json = JSON.parse(this.responseText);
		          jsonData2 = json.hourly_forecast;
		          netCheck(longitude, latitude);
		     }; //getData.onload closing
		     getData.open("GET", url);
		     getData.send();
		} else {
		     alert("Network currently unavailable.");
		     test=false;
		     read();
		}; 
};
//exports netCheck function to app.js were it can be called.
exports.netCheck = netCheck;
exports.netCheck2 = netCheck2;


//Gets users current location
var currentLocation = function(){
		if(Titanium.Network.online==true){
			//Asks user for permission to get current location and also tells the user why it is needed.
			Ti.Geolocation.purpose = "To find weather conditions near you.";
			Titanium.Geolocation.getCurrentPosition( function(e) {
			    if (!e.success) {
			        alert('Could not retrieve location');
			        return;
			        test=false;
			        read();
			    }else{
			    var longitude = e.coords.longitude;
			    var latitude = e.coords.latitude;
				netCheck2(longitude, latitude);
				
				};
				
			});
		}else{
			var netWork = Ti.UI.createAlertDialog({
				    message: 'Could not retrieve location',
				    title: 'Network Unavailable',
				  });
			netWork.show();
			test=false;
			read();
		};
	};
exports.currentLocation = currentLocation;

Ti.Database.install("weather.sqlite", "weather");


var create = function(city,state,condition,temp){
	var db = Ti.Database.open("weather");
	db.execute('INSERT INTO data (city,state,condition,temp) VALUES(?,?,?,?)', city,state,condition,temp);
	var rowID = db.lastInsertRowId;
	db.close();
	tblData = [];
};
exports.create = create;


var tblData = [];
var read = function(window){
var db = Ti.Database.open("weather");
	var dbRows = db.execute("SELECT id,city,state,condition,temp FROM data");
	while (dbRows.isValidRow()) {
		tblData.push({
			id: dbRows.fieldByName("id"),
			city: dbRows.fieldByName("city"),
			state: dbRows.fieldByName("state"),
			condition: dbRows.fieldByName("condition"),
			temp: dbRows.fieldByName("temp"),
			
		});
		dbRows.next();
	};
	if (test == true){
		ui.userInterface(tblData, jsonData2);
		}else{
		ui2.userInterface2(tblData, jsonData2);	
		};
	dbRows.close();
	db.close();
	ui.profilesTable = tblData;
	
};
exports.read = read;

