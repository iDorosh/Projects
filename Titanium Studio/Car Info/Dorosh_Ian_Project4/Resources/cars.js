var data = {
	"superCars":{
		"headTitle": "Top Cars",
		"footTitle": "7 Of The Top Cars In The World",
		"cars": [
			{
				title: "Lamborgini Aventador", 
				description: "Engine Size: 6.5L\nMSRP: $397,500\nMPG: 11 city, 18 highway\nHorsepower: 691 to 720\nTrims: LP700-4, LP720-4 50th Anniversario", 
				logo: "Lamborgini.png",
				topSpeed: "90%",
				horsePower: "80%",
			},
			{
				title: "Ferrari 458", 
				description: "Engine Size: 4.5L\nMSRP: $233,509\nMPG: 13 city, 17 highway\nHorsepower: 570\nTrims: 2 Door Coupe", 
				logo: "Ferrari.png",
				topSpeed: "80%",
				horsePower: "60%",
			},
			{
				title: "Porsche 911", 
				description: "Engine Size: 3.6L\nMSRP: $245,000\nMPG: 19 city, 27 highway\nHorsepower: 620\nTrims: GT2 RS, GT3 RS", 
				logo: "Porsche.png",
				topSpeed: "50%",
				horsePower: "60%",
			},
			{
				title: "Nissan GTR",
				description: "Engine Size: 3.8L\nMSRP: $101,770\nMPG: 16 city, 23 highway\nHorsepower: 545 to 600\nTrims: Premium, Black Edition, Nismo",
				logo: "Nissan.png",
				topSpeed: "90%",
				horsePower: "70%",
			},
			{
				title: "Rolls Royce Phantom", 
				description: "Engine Size: 6.8L\nMSRP: $474,990\nMPG: 11 city, 19 highway\nHorsepower: 453\nTrims: Base, Sedan", 
				logo: "RollsRoyce.png",
				topSpeed: "40%",
				horsePower: "50%",
			},
			{
				title: "Audi S7", 
				description: "Engine Size: 3.0L\nMSRP: $65,900\nMPG: 24 city, 38 highway\nHorsepower: 240 to 310\nTrims: 3.0 Premium Plus, 3.0T Premium Plus",
				logo: "Audi.png",
				topSpeed: "30%",
				horsePower: "50%",
			},
			{
				title: "BMW 7 Series", 
				description: "Engine Size: 3.0L, 4.4L, 6.0L\nMSRP: $74,000\nMPG: 19 city, 29 highway\nHorsepower: 255 to 535\nTrims: 740i, 740Li, 750Li", 
				logo: "BMW.png",
				topSpeed: "60%",
				horsePower: "50%",
			},
		]
	}
};


dataView = Ti.UI.createWindow({
	title: "Data",
	backgroundColor: "#fff",
	fullscreen: true,
	url:"cars.js"
});
	
var cars = Ti.UI.createTableView({
});



if(Ti.Platform.name === "iPhone OS"){
	cars.style = Ti.UI.iPhone.TableViewStyle.GROUPED;
};

	var superCarsSection = Ti.UI.createTableViewSection({
		headerTitle: data.superCars.headTitle,
		footerTitle: data.superCars.footTitle,
	});

var detail = function(data){
	var detailWindow = Ti.UI.createWindow({
		title: data.title,
		backgroundColor: "#aeaeae",
		fullscreen: true,
	});
	
	var detailText = Ti.UI.createLabel({
		text: data.desc,
		font: {fontSize: 18, fontFamily: "AmericanTypewriter", fontWeight: "light"},
		color: "#fff",
	});
	
	var detailTextBackground = Ti.UI.createView({
			backgroundColor:"#0c4375",
			height: 200,
			width: 300,
	});
	
	var behindDetailTextBackground = Ti.UI.createView({
			backgroundColor:"#128dff",
			height: 190,
			width: 307,
	});
	
	var pictures= Ti.UI.createImageView({
		image: "images/"+data.logo,
		height: "25%",
		top: 20,
	});
	
	var topSpeedBar = Ti.UI.createView({
			backgroundColor:"#fff",
			borderRadius: 10,
			height: 20,
			width: 165,
			right: 20,
			bottom:"20%",
	});
	
	var actualTopSpeed = Ti.UI.createView({
			backgroundColor:"#0c4375",
			borderRadius: 10,
			height: 20,
			left: 0,
			width:data.topSpeed,
	});
	
		var horsePowerBar = Ti.UI.createView({
			backgroundColor:"#fff",
			borderRadius: 10,
			height: 20,
			width: 165,
			right: 20,
			bottom:"10%",
	});
	
	var actualHorsePower = Ti.UI.createView({
			backgroundColor:"#0c4375",
			borderRadius: 10,
			height: 20,
			left: 0,
			width:data.horsePower,
	});
	
		var speed = Ti.UI.createLabel({
		text: "Top Speed",
		bottom: "20%",
		left: 20,
		font: {fontSize: 18, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#fff",
	});
	
		var horsePower = Ti.UI.createLabel({
			text: "Horse Power",
			bottom: "10%",
			left: 20,
			font: {fontSize: 18, fontFamily: "Helvetica", fontWeight: "light"},
			color: "#fff",
		});

	
	navWindow.openWindow(detailWindow);
	
	horsePowerBar.add(actualHorsePower);
	topSpeedBar.add(actualTopSpeed);
	detailTextBackground.add(detailText);
	detailWindow.add(behindDetailTextBackground, detailTextBackground, pictures, topSpeedBar, horsePowerBar, speed, horsePower);
	
};

for(var i=0, j=data.superCars.cars.length; i<j; i++){
	var row = Ti.UI.createTableViewRow({
		title: data.superCars.cars[i].title,
		desc: data.superCars.cars[i].description,
		logo: data.superCars.cars[i].logo,
		topSpeed: data.superCars.cars[i].topSpeed,
		horsePower: data.superCars.cars[i].horsePower,
		hasChild: true,
	});
	
	if(Ti.Platform.name === "iPhone OS"){
		row.hasChild = false;
		row.hasDetail = true;
	};
	
	superCarsSection.add(row);
};

cars.addEventListener("click", function(event){
	detail(event.source);
});

var carsSections = [superCarsSection];
cars.setData(carsSections);
dataView.add(cars);
