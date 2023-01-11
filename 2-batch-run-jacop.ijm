// TO RUN: select batch directory for analysis

// GOALS:
// 1) read in threshholded images and run JACoP
mainDir = getDirectory("Choose a directory containing your tif files:"); 
mainList = getFileList(mainDir); 

// make sub directory for the analysis
newDir = mainDir+"jacop-output"+File.separator;
File.makeDirectory(newDir);

imageType = ".tiff";
Suffix = "_merged" + imageType;

for (m=0; m<mainList.length; m++) { //clunky, loops thru all items in folder looking for image
	if (endsWith(mainList[m], Suffix)) { 
		open(mainDir+mainList[m]); //open image/movie file
		title = getTitle(); //save the title of the movie
		index = indexOf(title, Suffix); // find the number of the file - example, experiment number 10
        name = substring(title, 0, index);
		// split channels and open jacop
		run("Split Channels");
		run("JACoP ", "imga=C1-"+title+" imgb=C2-"+title+" thra=100 thrb=400 pearson mm");
		//wait(2000); // pause for 5 second to run jacop
		saveAs("Text", newDir+name+"_Log.txt");
		selectWindow("Log");
        run("Close" );
		run("Close"); // close last 2 image windows
		run("Close");
	}
}