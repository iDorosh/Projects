
var carTypes = ["Lamborgini Aventador", "Ferrari 458", "Audi R8", "Mclaren P1", "Aston Martin DB9", "Maserati GT", "Bugatti Veyron", "Koenigsegg Agera", "Pegani Huayra", "Mercedes SLK" ];
var listCars = 0;

var next = function(){
	listCars++;
	if (listCars >= carTypes.length) {
		listCars = 0;
		mainText.text = carTypes[listCars];
	} else {		
		mainText.text = carTypes[listCars];	
	};
};

var previous = function(){
	if (listCars <= 0) {
		listCars = carTypes.length - 1;
		mainText.text = carTypes[listCars];
	} else {
		listCars--;		
		mainText.text = carTypes[listCars];	
	};
};

var firstCar = function(){
	mainText.text = carTypes[0];
};


firstCar();
nextButton.addEventListener("click", next);
previousButton.addEventListener("click", previous); 