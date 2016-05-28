var currentWindow = Ti.UI.currentWindow;
var car;
var engineSize;
var horsePower;
var cost;


var picker = Ti.UI.createPicker({
  top:30
});

var data = [];
data[0]=Ti.UI.createPickerRow({title:'Lamborgini Aventador'});
data[1]=Ti.UI.createPickerRow({title:'Ferrari Enzo'});
data[2]=Ti.UI.createPickerRow({title:'Audi R8'});
data[3]=Ti.UI.createPickerRow({title:'Aston Martin DB9'});

picker.add(data);
picker.selectionIndicator = true;

currentWindow.add(picker);

picker.setSelectedRow(0, 2, true); 

var select = Ti.UI.createLabel({
	top:15,
	text: "Choose Your Car",
	color: "#0c4375",
	font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "light"},
});


var picker2 = Ti.UI.createPicker({
  top:250,

});

var data2 = [];
data[0]=Ti.UI.createPickerRow({title:'3.0L', horsePower: '350', cost: '$320,000'});
data[1]=Ti.UI.createPickerRow({title:'3.5L', horsePower: '450', cost: '$380,000'});
data[2]=Ti.UI.createPickerRow({title:'5.0L', horsePower: '550', cost: '$400,000'});
data[3]=Ti.UI.createPickerRow({title:'6.2L', horsePower: '750', cost: '$620,000'});

picker2.add(data);
picker2.selectionIndicator = true;

currentWindow.add(picker2);

picker2.setSelectedRow(0, 1, true); 

var selectEngine = Ti.UI.createLabel({
	top:235,
	text: "Choose Your Engine Size",
	color: "#0c4375",
	font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "light"},
});

var orderNowView = Ti.UI.createView({
	backgroundColor: "#0c4375",
	height:50, 
	bottom:0,
});

var orderNowLabel = Ti.UI.createLabel({
	text: "Order Now",
	color: "fff",
	font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "light"},
});

picker.addEventListener('change', function(e){
    car = picker.getSelectedRow(0).title;
});

picker2.addEventListener('change', function(e){
    engineSize = picker2.getSelectedRow(0).title;
    horsePower = picker2.getSelectedRow(0).horsePower;
    cost = picker2.getSelectedRow(0).cost;
});

orderNowView.addEventListener("click", function(placeOrder){
	var sold = Titanium.UI.createAlertDialog({
    title: "Congratulations",
    message: "Your order has been placed! You will recieve your brand new " + car + " with a " + engineSize + " engine and "+ horsePower + " Horse Power in 5 days.\n Total Cost is "+ cost,
});
sold.show();
	
	
});

orderNowView.add(orderNowLabel);
currentWindow.add(select, selectEngine, orderNowView);

