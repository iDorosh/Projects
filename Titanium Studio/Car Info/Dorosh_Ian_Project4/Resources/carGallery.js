var imagesFolder = Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, "photos");
var imageFiles = imagesFolder.getDirectoryListing();

var pWidth = Ti.Platform.displayCaps.platformWidth;
var pHeight = Ti.Platform.displayCaps.platformHeight;

var currentWindow = Ti.UI.currentWindow;
var previousNum;

var newImage = Ti.UI.createImageView({
	title: "imageFiles",
	image: "photos/",
});


var random = function(){
	number = Math.floor(Math.random()*10);
		while(number == previousNum){
			number = Math.floor(Math.random()*10);
		};
	previousNum = number;
	newImage.image = "photos/" + imageFiles[number];
};

var nextPicButton = Ti.UI.createView({
	height: 50,
	width: pWidth,
	bottom: 0,
	backgroundColor: "#000",
});
		
var nextPicButtonLabel = Ti.UI.createLabel({
	text: "Next Image",
	color: "fff",
	font: {fontSize: 18, fontFamily: "Helvetica"},
});

nextPicButton.addEventListener("click",function(f){
  random();
});

random();

currentWindow.add(newImage);
nextPicButton.add(nextPicButtonLabel);
currentWindow.add(nextPicButton);


