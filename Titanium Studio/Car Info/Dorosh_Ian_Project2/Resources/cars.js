var data = {
	"superCars":{
		"headTitle": "Super Cars",
		"footTitle": "Need For Speed",
		"cars": [
			{
				title: "Lamborgini Aventador", 
				description: "Engine Size: 6.5L\nMSRP: $397,500\nMPG: 11 city, 18 highway\nHorsepower: 691 to 720\nTrims: LP700-4, LP720-4 50th Anniversario", 
				logo: "Lamborgini.png"
			},
			{
				title: "Ferrari 458", 
				description: "Engine Size: 4.5L\nMSRP: $233,509\nMPG: 13 city, 17 highway\nHorsepower: 570\nTrims: 2 Door Coupe", 
				logo: "Ferrari.png"
			},
			{
				title: "Porsche 911", 
				description: "Engine Size: 3.6L\nMSRP: $245,000\nMPG: 19 city, 27 highway\nHorsepower: 620\nTrims: GT2 RS, GT3 RS", 
				logo: "Porsche.png"
			},
			{
				title: "Nissan GTR",
				description: "Engine Size: 3.8L\nMSRP: $101,770\nMPG: 16 city, 23 highway\nHorsepower: 545 to 600\nTrims: Premium, Black Edition, Nismo",
				logo: "Nissan.png",
			}
		
		]
		
	},
	"luxuryCars":{
		"headTitle": "Luxury Cars",
		"footTitle": "Time To Relax And Enjoy The Ride",
		"cars": [
			{
				title: "Rolls Royce Phantom", 
				description: "Engine Size: 6.8L\nMSRP: $474,990\nMPG: 11 city, 19 highway\nHorsepower: 453\nTrims: Base, Sedan", 
				logo: "RollsRoyce.png"
			},
			{
				title: "Audi S7", 
				description: "Engine Size: 3.0L\nMSRP: $65,900\nMPG: 24 city, 38 highway\nHorsepower: 240 to 310\nTrims: 3.0 Premium Plus, 3.0T Premium Plus",
				logo: "Audi.png"
			},
			{
				title: "BMW 7 Series", 
				description: "Engine Size: 3.0L, 4.4L, 6.0L\nMSRP: $74,000\nMPG: 19 city, 29 highway\nHorsepower: 255 to 535\nTrims: 740i, 740Li, 750Li", 
				logo: "BMW.png"
			},
		]
	}
};


if(Ti.Platform.name === "iPhone OS"){
	cars.style = Ti.UI.iPhone.TableViewStyle.GROUPED;
};

	var superCarsSection = Ti.UI.createTableViewSection({
		headerTitle: data.superCars.headTitle,
		footerTitle: data.superCars.footTitle,
	});
	
	var luxuryCarsSection = Ti.UI.createTableViewSection({
		headerTitle: data.luxuryCars.headTitle,
		footerTitle: data.luxuryCars.footTitle,
});


var detail = function(){
	var detailWindow = Ti.UI.createWindow({
		title: this.title,
		backgroundColor: "#6c6c6c",
	});
	
	var detailText = Ti.UI.createLabel({
		text: this.desc,
		font: {fontSize: 18, fontFamily: "AmericanTypewriter", fontWeight: "light"},
		color: "#fff",
	});
	
	var detailTextBackground = Ti.UI.createView({
			backgroundColor:"#000",
			height: 200,
			width: 300,
	});
	
	var behindDetailTextBackground = Ti.UI.createView({
			backgroundColor:"#ff0000",
			height: 190,
			width: 305,
	});
	
	var pictures= Ti.UI.createImageView({
		image: "images/"+this.logo,
		height: 80,
		top: 40,
	});
	
	navWindow.openWindow(detailWindow);
	
	detailTextBackground.add(detailText);
	detailWindow.add(behindDetailTextBackground, detailTextBackground, pictures);
	
};

for(var i=0, j=data.superCars.cars.length; i<j; i++){
	var row = Ti.UI.createTableViewRow({
		title: data.superCars.cars[i].title,
		desc: data.superCars.cars[i].description,
		logo: data.superCars.cars[i].logo,
		hasChild: true,
	});
	
	if(Ti.Platform.name === "iPhone OS"){
		row.hasChild = false;
		row.hasDetail = true;
	};
	
	superCarsSection.add(row);
	row.addEventListener("click", detail);
};

for(var i=0, j=data.luxuryCars.cars.length; i<j; i++){
	var row = Ti.UI.createTableViewRow({
		title: data.luxuryCars.cars[i].title,
		desc: data.luxuryCars.cars[i].description,
		logo: data.luxuryCars.cars[i].logo,
		hasChild: true,
	});
	
	if(Ti.Platform.name === "iPhone OS"){
		row.hasChild = false;
		row.hasDetail = true;
	};
	
	luxuryCarsSection.add(row);
	row.addEventListener("click", detail);
};

var carsSections = [superCarsSection, luxuryCarsSection ];

cars.setData(carsSections);