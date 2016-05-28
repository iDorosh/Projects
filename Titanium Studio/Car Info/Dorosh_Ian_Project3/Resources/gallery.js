var imagesFolder = Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, "photos");
var imageFiles = imagesFolder.getDirectoryListing();

var pWidth = Ti.Platform.displayCaps.platformWidth;
var pHeight = Ti.Platform.displayCaps.platformHeight;
var rowCount = 4;
var margin = 5;
var trueCanvasWidth = pWidth-margin;
var size = trueCanvasWidth/rowCount-margin;


var viewContainer = Ti.UI.createScrollView({
	top:0,
	width: pWidth,
	backgroundColor :"#fff",
	layout: "horizontal",
	contentWidth: pWidth,
	height: pHeight-64,
	showVerticalScrollIndicator: true,
});

for(var i=0; i<imageFiles.length; i++){
	var view = Ti.UI.createView({
		backgroundColor: "#fff",
		top: margin,
		left: margin,
		width: size,
		height: size,
		borderRadius: 5,
	});
	
	var newImage = Ti.UI.createImageView({
		title: imageFiles[i],
		image: "photos/" + imageFiles[i],
		top: 0,
		width: view.width*2,
	});
	
	view.add(newImage);
	viewContainer.add(view);
};

viewContainer.addEventListener("click", function(event){
		photoView(event.source.title);
});



var photoView = function(data){
	if (typeof data == "string"){
	
		var detailWindow = Ti.UI.createWindow({
			backgroundColor: "#fff",
			title: data,
		});
		
		var pictures = Ti.UI.createImageView({
			image: "photos/" + data,
			width: pWidth,
			enableZoomControls: true,
		});
	
		navWindow.openWindow(detailWindow);
		detailWindow.add(pictures);
	};

};

galleryView.add(viewContainer);