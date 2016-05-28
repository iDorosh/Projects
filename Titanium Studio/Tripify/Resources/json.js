var data = {
	"trips": [
			{
				title: "Bahamas", 
				description: "Trip includes a amazing ocean view from the balcony of your 5 star hotel. The suites inlucde a kitchen, bathroom with jaccuzi and shower, along complemetry breakfest. Outside you will find resturants and 6 choices of pools or you can head over to our white sand beaches.", 
				image: "images/vacation.jpg",	
				length: "10 day trip to the Bahamas",
				price: 940,	
				people: 2,
			},
			{
				title: "Jamaica", 
				description: "Enjoy an all inclusive trip to Jamaica. You will experience a 4 star hotel with your own mini fridge that includes free beverages which are stocked daily. Breakfest, Lunch and Dinner are all included in the price of the trip, enjoy your choice of 9 resturants, pools and the beach.", 
				length: "7 day trip to the Jamaica",
				image: "images/Jamaica.jpg",	
				price: 500,
				people: 1,
			},
			{
				title: "Hawaii", 
				description: "Trip includes a amazing ocean view from the balcony of your 5 star hotel. The suites inlucde a kitchen, bathroom with jaccuzi and shower, along complemetry breakfest. Outside you will find resturants and 6 choices of pools or you can head over to our white sand beaches.", 
				length: "12 day trip to the Hawaii",
				image: "images/Hawaii.jpg",	
				price: 2400,
				people: 4,
			},
			{
				title: "Alaska",
				description: "Enjoy hunting or fishing, Alaska is the perfect place for you. Enjoy camping trips with the family in the wild while being safe in a park reserve with no bears or wolves. The kids will enjoy our indoor swimming pools located on the reserve and our trip is also all inclusive.",
				length: "10 day trip to the Alaska",
				image: "images/alaska.jpg",	
				price: 600,
				people: 2,
			},
			{
				title: "Norway", 
				description: "Are you sick of hot weather come to Norway where it doesnt get above freezing all winter long! Enjoy our 4 star hotels with all inclusive breakfest lunch and dinner. We have 4 resturants featuring entres that any one will love to eat. You will also enjoy your view of the mountains from your hotel room.", 
				length: "10 day trip to the Norway",
				image: "images/norway.jpg",	
				price: 1640,
				people: 1,
			},
			{
				title: "Paris", 
				description: "Paris is a beautiful city filled with amazing places to visit. You will enjoy coming to a relaxing 5 star hotel room with a jaccuzi and full kitchen, stocked daily with fresh fruit and drinks. Many of our guests also enjoy swimming in our indoor water park that is included in the price of your hotel.",
				length: "7 day trip to the Paris",
				image: "images/paris.jpg",	
				price: 3200,
				people: 2,
			},
			{
				title: "Italy", 
				description: "", 
				length: "10 day trip to the Italy",
				image: "images/italy.jpg",	
				price: 1300,
				people: 1,
			},
			{
				title: "Germany", 
				description: "Germany is a beautiful country filled with amazing places to visit. You will enjoy coming to a relaxing 5 star hotel room with a jaccuzi and full kitchen, stocked daily with fresh fruit and drinks. Many of our guests also enjoy swimming in our indoor water park that is included in the price of your hotel.", 
				length: "10 day trip to the Germany",
				image: "images/germany.jpg",	
				price: 1200,
				people: 1,
			},
			{
				title: "England", 
				description: "England is a beautiful country filled with amazing places to visit. You will enjoy coming to a relaxing 5 star hotel room with a jaccuzi and full kitchen, stocked daily with fresh fruit and drinks. Many of our guests also enjoy swimming in our indoor water park that is included in the price of your hotel.", 
				length: "10 day trip to the England",
				image: "images/london.jpg",	
				price: 6400,
				people: 4,
			},
			{
				title: "Cancun", 
				description: "Enjoy an all inclusive trip to Cancun. You will experience a 4 star hotel with your own mini fridge that includes free beverages which are stocked daily. Breakfest, Lunch and Dinner are all included in the price of the trip, enjoy your choice of 9 resturants, pools and the beach.", 
				length: "10 day trip to the Cancun",
				image: "images/cancun.jpg",	
				price: 670,	
				people: 2,		
			},
			{
				title: "Mexico", 
				description: "Trip to Mexico includes a amazing ocean view from the balcony of your 5 star hotel. The suites inlucde a kitchen, bathroom with jaccuzi and shower, along complemetry breakfest. Outside you will find resturants and 6 choices of pools or you can head over to our white sand beaches.", 
				length: "9 day trip to the Mexico",
				image: "images/mexico.jpg",	
				price: 900,
				people: 1,
			},
			{
				title: "Brazil", 
				description: "Brazil is a beautiful country filled with amazing places to visit. You will enjoy coming to a relaxing 5 star hotel room with a jaccuzi and full kitchen, stocked daily with fresh fruit and drinks. Many of our guests also enjoy swimming in our indoor water park that is included in the price of your hotel.", 
				length: "6 day trip to the Brazil",
				image: "images/brazil.jpg",	
				price: 900,
				people: 1,
			},
		]
};

var data2 = {
	"users":[
			{
				userName: "iDorosh", 
				password: "Doroshi", 		
			},
			{
				userName: "JMiller", 
				password: "Miller132", 			
			},
			{
				userName: "AJohnson", 
				password: "AliJ", 		
			},
			{
				userName: "AlexDorosh", 
				password: "doroalex", 		
			},
			{
				userName: "LJefferson", 
				password: "jefferson132", 	
			},
			{
				userName: "", 
				password:"", 	
			},
		]
};

//Login Screen Views and labels 
var mainScreen = Ti.UI.createWindow({
	backgroundColor: "#94bc5b",
	fullscreen: true,
	navBarHidden: false,
	title: "Home",
	backButtonTitle: "Home",
	rightButtonTitle: "Trips",
	navTintColor: "#759547",
});

var createScrollMain = Ti.UI.createScrollView({
		contentWidth: "auto",
		contentHeight: "400",
		showVerticalScrollIndicator: true,
		height: "100%",
	    width: "100%"
	});

var tripify = Ti.UI.createLabel({
	top: 40,
	text: "Tripify",
	color: "fff",
	font: {fontSize: 64, fontFamily: "Helvetica", fontWeight: "bold"},
});

var logInBG = Ti.UI.createView({
	top: 140,
	backgroundColor: "#94bc5b",
	height: 40,
	width: 90,
});

var logIn = Ti.UI.createLabel({
	text: "Sign In",
	color: "#fff",
	font: {fontSize: 22, fontFamily: "Helvetica", fontWeight: "regular"},
});

var logInBars = Ti.UI.createView({
	top: 160,
	backgroundColor: "#fff",
	height: 1,
	width: "240",
});

var userName = Titanium.UI.createTextField({
	top:210,
    color: "#94bc5b",
    height:50,
    width:"240",
    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED, 
    hintText:"username", 
    autoCorrect: false,
	autocapitalization: Titanium.UI.TEXT_AUTOCAPITALIZATION_NONE,
});

var password = Titanium.UI.createTextField({
	top:280,
    color: "#94bc5b",
    height:50,
    width:"240",
    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED,
    hintText:"password",
    passwordMask:true,
    autoCorrect: false,
	autocapitalization: Titanium.UI.TEXT_AUTOCAPITALIZATION_NONE,
});

var logInButton = Ti.UI.createLabel({
	top: password.top+70,
	text: "Login",
	color: "#fff",
	font: {fontSize: 28, fontFamily: "Helvetica", fontWeight: "Lite"},
});

var bottomBars = Ti.UI.createView({
	bottom: 70,
	backgroundColor: "#fff",
	height: 1,
	width: "240",
});

var create = Ti.UI.createLabel({
	bottom: 25,
	text: "Create",
	color: "#fff",
	font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "lite"},
});

var tripsLogin = Titanium.UI.createButton({
	    title:'Trips',
	    color: "#759547",
	    backgroundImage: "none",
	    style:Titanium.UI.iPhone.SystemButtonStyle.BORDERED
	});


var a = Titanium.UI.createButton({
	    title:'Log Out',
	    color: "#759547",
	    backgroundImage: "none",
	    style:Titanium.UI.iPhone.SystemButtonStyle.BORDERED
	});

var c = Titanium.UI.createButton({
	    title:'Sign In',
	    color: "#759547",
	    backgroundImage: "none",
	    style:Titanium.UI.iPhone.SystemButtonStyle.BORDERED
	});


// Opens login screen in navigation window and sets the right navigation button to login
logInButtonHome.addEventListener("click", function(home){
	navWindow.openWindow(mainScreen);
	mainScreen.rightNavButton = tripsLogin;
});

tripsLogin.addEventListener("click", function(home){
	navWindow.openWindow(dataView);
	navWindow.closeWindow(mainScreen);
	navWindow.closeWindow(createWin);
	dataView.rightNavButton = c;
});

//Event listeners for loging out and loging out confirmation
a.addEventListener("click", function(home){
	var logOutA = Titanium.UI.createAlertDialog({
		title:"Are You Sure? "+ userName.value,
		message:"Confirm Logout",
		cancel: 1,
    	buttonNames: ['Log Out', 'Cancel'],
	});
	logOutA.show();
		  	logOutA.addEventListener('click', function(home){
				if (home.index === home.source.cancel){   //listens to the cancel button being click if it is it closes alert and doesnt log user out if log out is click it logs out user
					dataView.rightNavButton = a;
			    }else{
				      dataView.rightNavButton = c;
				 	 }
	 		});
});
 
c.addEventListener("click", function(home){
	navWindow.closeWindow(createWin);
	navWindow.openWindow(mainScreen);
	navWindow.closeWindow(dataView);
});	
		

logInBG.add(logIn),
createScrollMain.add(tripify, logInBars, logInBG, userName, password, logInButton, bottomBars, create);
mainScreen.add(createScrollMain);
navWindow.open();



//Create Account Window
var createWin = Ti.UI.createWindow({
	backgroundColor: "#efefef",
	title: "Create Account",
	fullscreen: true,
	 backButtonTitle: "Log In",
	 navTintColor: "#759547",
});

var createScroll = Ti.UI.createScrollView({
		contentWidth: "auto",
		contentHeight: "460",
		showVerticalScrollIndicator: true,
		height: "100%",
	    width: "100%"
	});
	
	var tripifyCreate = Ti.UI.createLabel({
		top: 40,
		text: "Tripify",
		color: "#94bc5b",
		font: {fontSize: 64, fontFamily: "Helvetica", fontWeight: "bold"},
	});
	
	var createBG = Ti.UI.createView({
		top: 140,
		backgroundColor: "#efefef",
		height: 60,
		width: 180,
	});
	
	var createAccount = Ti.UI.createLabel({
		text: "Create Account",
		color: "#94bc5b",
		font: {fontSize: 22, fontFamily: "Helvetica", fontWeight: "regular"},
	});
	
	var createBars = Ti.UI.createView({
		top: 170,
		backgroundColor: "#94bc5b",
		height: 1,
		width: "240",
	});
	
	var createUserName = Titanium.UI.createTextField({
		top:210,
	    color: "#94bc5b",
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED, //This is a constant that can be used to style textfields in iOS
	    hintText:"create username", //Hint text is displayed to the user before the field has been edited
		autoCorrect: false,
		autocapitalization: Titanium.UI.TEXT_AUTOCAPITALIZATION_NONE,
	});
	
	var createPassword = Titanium.UI.createTextField({
		top:270,
	    color: "#94bc5b",
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED, //This is a constant that can be used to style textfields in iOS
	    hintText:"create password", //Hint text is displayed to the user before the field has been edited
		passwordMask:true,
		autoCorrect: false,
		autocapitalization: Titanium.UI.TEXT_AUTOCAPITALIZATION_NONE,
	});
	
	var requierments = Ti.UI.createLabel({
		text: "6-20 characters",
		top: createPassword.top+55,
		left: 42,
		color: "#b6b6b9",
		font: {fontSize: 12, fontFamily: "Helvetica", fontWeight: "regular"},
		
	});
	
	var confirmPassword = Titanium.UI.createTextField({
		top:350,
	    color: "#94bc5b",
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED, //This is a constant that can be used to style textfields in iOS
	    hintText:"confirm password",
	    passwordMask:true,//Hint text is displayed to the user before the field has been edited
	});
	
	var createButton = Ti.UI.createLabel({
		top: confirmPassword.top+65,
		text: "Create",
		color: "#94bc5b",
		font: {fontSize: 26, fontFamily: "Helvetica", fontWeight: "Lite"},
	});
	
	var b = Titanium.UI.createButton({
	    title:'Trips',
	    color: "#759547",
	    backgroundImage: "none",
	    style:Titanium.UI.iPhone.SystemButtonStyle.BORDERED
	});

	createWin.rightNavButton = b;
	createBG.add(createAccount);
	createScroll.add(tripifyCreate, createUserName, createBars, createBG, createPassword, confirmPassword, requierments, createButton);
	createWin.add(createScroll);






//Window to hold my table View 
dataView = Ti.UI.createWindow({
	navBarHidden: false,
	title: "Trips",
	fullscreen: true,
	backButtonTitle: "Home",
	navTintColor: "#759547",
});


var search = Titanium.UI.createSearchBar({
    barColor:'#8ac350', 
    height:43,
    top:0,
    hintText: "Search Trips",
});


//Detail Window
//Function that creates my detail window when a item is pressed.
var rowData = [];
var detail = function(testing){
	
	var detailWindow = Ti.UI.createWindow({
		title: testing.title,
		backgroundColor: "#94bc5b",
		fullscreen:true,
	 	navTintColor: "#759547",
		
	});
	
	var bg1 = Ti.UI.createView({
		top:180,
		backgroundColor: "#efefef",
		height: 115,
	    width: "100%"
	});
	
	var bg2 = Ti.UI.createView({
		top: 310,
		backgroundColor: "#efefef",
		height: 200,
	    width: "100%"
	});
	
	var bg3 = Ti.UI.createView({
		top:525,
		backgroundColor: "#efefef",
		height: 70,
	    width: "100%"
	});

	var request = Ti.UI.createLabel({
		text: "Request Informaion",
		font: {fontSize: 32, fontFamily: "Helvetica", fontWeight: "Bold"},
		color: "#94bc5b",
	});
	
	var detailScroll = Ti.UI.createScrollView({
		contentWidth: "auto",
		contentHeight: 610,
		showVerticalScrollIndicator: true,
		height: "100%",
	    width: "100%"
	});
	
	var questionsText = Ti.UI.createLabel({
		text: testing.title,
		font: {fontSize: 16, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#000",
	});
	
	var quick = Ti.UI.createLabel({
		top: bg2.top+10,
		left: 15,
		text: "Quick Overview",
		font: {fontSize: 20, fontFamily: "Helvetiva", fontWeight: "light"},
		color: "#94bc5b",
	});
	
	
	var body = Ti.UI.createLabel({
		top: quick.top+30,
		left: 15,
		right:15,
		text: testing.desc,
		font: {fontSize: 16, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#60605f",
	});
	
	var detailImage = Titanium.UI.createImageView({
		top: 0,
		image: testing.image,
		height:180,
		width:320,
	});
	
	var length = Ti.UI.createLabel({
		top: detailImage.top+190,
		text: testing.length,
		font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "bold"},
		color: "#3a3a3b",
		left: 15,
	});
	
	var tripPrice = Ti.UI.createLabel({
		top: length.top+30,
		text: "$"+testing.price,
		font: {fontSize: 20, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#94bc5b",
		left: 15,
	});
	

	var detailBars = Titanium.UI.createView({
		backgroundColor: "#94bc5b",
		top: 260,
		height:1,
		width:310,
	});
	
	var numberPeople = Ti.UI.createLabel({
		top: detailBars.top+8,
		text: testing.people,
		font: {fontSize: 16, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#94bc5b",
		left: 70,
	});
	
	var forAmount = Ti.UI.createLabel({
		top: detailBars.top+8,
		text: "Trip for",
		font: {fontSize: 16, fontFamily: "Helvetica", fontWeight: "light"},
		color: "#878885",
		left: 13,
	});
	
	bg3.addEventListener("click", function(orderForm){
		navWindow.openWindow(order);
	});
	
	bg3.add(request);
	detailScroll.add(bg1, detailImage, tripPrice,length, detailBars, numberPeople, forAmount, bg2, quick, body, bg3);
	detailWindow.add(detailScroll);
	navWindow.openWindow(detailWindow);
	
};



//for loop to generate all my buttons in the table view
for(var i=0, j=data.trips.length; i<j; i++){
	var img = Titanium.UI.createImageView({
			image: data.trips[i].image,
			height:180,
			width:320,
			title: data.trips[i].title,
			desc: data.trips[i].description,
			price: data.trips[i].price,
			length: data.trips[i].length,
			people: data.trips[i].people,
			
		});
		
		var bgBar = Titanium.UI.createView({
			height:36,
			width:"100%",
			bottom:0,
			left:0,
			backgroundColor:"#96bd5e",
			title: data.trips[i].title,
			desc: data.trips[i].description,
			price: data.trips[i].price,
			length: data.trips[i].length,
			people: data.trips[i].people,
		});
		
		var title = Titanium.UI.createLabel({
			image: data.trips[i].image,
			text: data.trips[i].title,//The title property of the data array
			height:36,
			width:"75%", //Ideally the screen width
			bottom:0,
			left:10,
			color:"#FFFFFF",
			title: data.trips[i].title,
			desc: data.trips[i].description,
			price: data.trips[i].price,
			length: data.trips[i].length,
			people: data.trips[i].people,
			textAlign:"left"
		});
	
		var amount = Titanium.UI.createLabel({
			text:"$" + data.trips[i].price,//The amount property of the data array
			height:36,
			width:"25%",
			bottom:0,
			right:10,
			color:"#FFFFFF",
			textAlign:"right",
			image: data.trips[i].image,
			title: data.trips[i].title,
			desc: data.trips[i].description,
			price: data.trips[i].price,
			length: data.trips[i].length,
			people: data.trips[i].people,
		});
		
		//Create the row
		var row = Titanium.UI.createTableViewRow({
			searchFilter: data.trips[i].title,
			desc: data.trips[i].description,
			height:"auto",//Set the height of the row to auto so that it expands freely in the vertical direction
			title: data.trips[i].title,
		});
		
		//Add the views to the row
		row.add(img);
		row.add(bgBar);
		row.add(title);
		row.add(amount);
		
		
		rowData.push(row);
	};

			var questions = Ti.UI.createTableView({
				search: search,
				filterAttribute: "searchFilter",
				data: rowData,
				
			});
			questions.setData(rowData);
			dataView.add(questions);

//Using Event Propagation instead of making an event listener to every button.
questions.addEventListener("click", function(event){
	detail(event.source);
});





//Order Window
var order = Ti.UI.createWindow({
	backgroundColor: "#efefef",
	title: "Order",
	fullscreen: true,
	navTintColor: "#759547",
});

var infoScroll = Ti.UI.createScrollView({
		contentWidth: "auto",
		contentHeight: "auto",
		showVerticalScrollIndicator: true,
		height: "100%",
	    width: "100%"
	});
	
var shipping = Ti.UI.createLabel({
		top: 30,
		text: "Shipping Information",
		color: "#94bc5b",
		font: {fontSize: 26, fontFamily: "Helvetica", fontWeight: "Lite"},
	});
	
var name = Titanium.UI.createTextField({
	    color: "#94bc5b",
	    top: 80,
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED, //This is a constant that can be used to style textfields in iOS
	    hintText:"first name",
	});
	
var lastName = Titanium.UI.createTextField({
	    color: "#94bc5b",
	    top: 140,
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED, //This is a constant that can be used to style textfields in iOS
	    hintText:"last name",
	});
	
var address = Titanium.UI.createTextField({
	    color: "#94bc5b",
	    top: 200,
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED, //This is a constant that can be used to style textfields in iOS
	    hintText:"address",
	});

var zip = Titanium.UI.createTextField({
	    color: "#94bc5b",
	    top: 260,
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED,
	    keyboardType:  Titanium.UI.KEYBOARD_NUMBER_PAD,
	    hintText:"zip", 
	});

var state = Titanium.UI.createTextField({
	    color: "#94bc5b",
	    top: 320,
	    height:50,
	    width:"240",
	    borderStyle:Titanium.UI.INPUT_BORDERSTYLE_ROUNDED,
	    hintText:"state", 
	});


var orderButton = Ti.UI.createLabel({
		top: 380,
		text: "Order",
		color: "#94bc5b",
		font: {fontSize: 32, fontFamily: "Helvetica", fontWeight: "Lite"},
	});

//event listener for order button
orderButton.addEventListener("click", function(confirm){
	if(address.value === "" || zip.value === "" || state.value === "" || name.value === "" || lastName.value === ""){ //checks to make sure all the information is submited by comparing user input to an open string.
		var errorOrder = Titanium.UI.createAlertDialog({ //displays alert for missing information
			title:"Error",
			message:"Empty fields\nPlease complete entire form"
		});
		errorOrder.show();
	} else{
	
		var confirmOrder = Titanium.UI.createAlertDialog({ // displays alert for order confirmation and shipment soon
			title:"Confirm Order",
			message:"Information will be shipped to\n "+ address.value +" "+ zip.value +" "+ state.value,
			cancel: 1,
	    	buttonNames: ['Confirm', 'Cancel'],
		});
			confirmOrder.show();
			  	confirmOrder.addEventListener('click', function(confirm){
					if (confirm.index === confirm.source.cancel){
						navWindow.closeWindow(order);
						
						var orderCancel = Titanium.UI.createAlertDialog({
							title:"Canceled",
							message:"Your order has been canceled"
						});
						orderCancel.show();
				       }else{
				       	navWindow.closeWindow(order);
				       	var orderSent = Titanium.UI.createAlertDialog({
							title:"Order Placed",
							message:"Your order has been placed and your free information will be sent shortly"
						});
						address.value = "";
						zip.value  = "";
						state.value  = "";
						name.value  = "";
						lastName.value  = "";
						orderSent.show();
				       }
		  });
	 };
});


infoScroll.add(name, shipping, lastName, address, zip, state, orderButton);
order.add(infoScroll);




//Event Listeners

//event lisetner for create button under new account screen is the two password match and if the passwords are longer than 6 charactors and shorter than 20 navigation bar will include log out button.
createButton.addEventListener("click", function(e){
if(createPassword.value === confirmPassword.value && createPassword.value !== "" && createPassword.value.length >= 6 && createPassword.value.length <= 20){
	navWindow.openWindow(dataView);
				navWindow.closeWindow(mainScreen);
				navWindow.closeWindow(createWin);
				dataView.rightNavButton = a;
};
});
//event lisetner for create button under new account screen is the two password match and if the passwords are longer than 6 charactors and shorter than 20 account will be created
createButton.addEventListener("click", function(e){
	
	if(createPassword.value === confirmPassword.value && createPassword.value !== "" && createPassword.value.length >= 6 && createPassword.value.length <= 20){
		
		var b = Titanium.UI.createAlertDialog({
		    title:"Welcome " + createUserName.value,
		    message:"Thank you for signing up!",
		});
			b.show();
	
	} else{
			var a = Titanium.UI.createAlertDialog({
			    title:"Error",
			    message:"Passwords don't match\nPlease try Again",
			});
			a.show();
		};
	
	data2.users[5].userName = createUserName.value;
	data2.users[5].password = createPassword.value;
	createPassword.value = "";
	createUserName.value = "";
	confirmPassword.value = "";
});

b.addEventListener("click", function(e){
	navWindow.openWindow(dataView);
	dataView.rightNavButton = c;
});

create.addEventListener("click", function(e){
	navWindow.openWindow(createWin);
});

viewTrips.addEventListener("click", function(e){
	navWindow.openWindow(dataView);
	dataView.rightNavButton = c;
});

//Log in button event listener contains a for loop to match the username to json data if username matches any username from json the user is logged in.
logInButton.addEventListener("click", function(e){
	for(var i=0, j=data2.users.length; i<j; i++){	
		 if(userName.value == data2.users[i].userName && password.value == data2.users[i].password && userName.value !== '' && password.value !== ''){
		 	navWindow.openWindow(dataView);	
		 	navWindow.closeWindow(mainScreen);
			dataView.rightNavButton = a;
				 	var c = Titanium.UI.createAlertDialog({
					    title:"Welcome "+ userName.value,
					    message:"Thank you for signing in",
					});
					password.value = "";
					userName.value = "";
					c.show();
					
		 }
	};
});

  


