// TO RUN: select batch directory for analysis

// GOALS:
// 1) read in max projected images and subtract background to prepare for jacop colocalization analysis
mainDir = getDirectory("Choose a directory containing your tif files:"); 
mainList = getFileList(mainDir); 

// make sub directory for the analysis
newDir = mainDir+"Output_tifs"+File.separator;
File.makeDirectory(newDir);

imageType = ".tif";
Suffix = imageType;

for (m=0; m<mainList.length; m++) { //clunky, loops thru all items in folder looking for image
	if (endsWith(mainList[m], Suffix)) { 
		open(mainDir+mainList[m]); //open image/movie file
		title = getTitle(); //save the title of the movie
		index = indexOf(title, Suffix); // find the number of the file - example, experiment number 10
        name = substring(title, 0, index);
		// split channels and prepare duplicate image for threshholding
		run("Split Channels");
		selectWindow("C1-"+title);
		// start with the green channel threshholding
		run("Duplicate...", " ");
		rename("green");
		run("Gaussian Blur...", "sigma=1");
		run("Subtract Background...", "rolling=50");
		setAutoThreshold("Yen dark");
		setThreshold(15, 65535);
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Analyze Particles...", "include add");
		close("green");
		// select all ROI and combine them
		count=roiManager("count");
		
		if (count > 1) {
			array=newArray(count);
			for(i=0; i<count;i++) {
        			array[i] = i;
			}
			roiManager("Select", array);
			roiManager("Combine"); // merge into one roi
			roiManager("Add");
			roiManager("Select", array);
			roiManager("Delete");
		} 
		
		selectWindow("C1-"+title);
		roiManager("Select", 0);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside"); // clear all grey values outside the threshhold ROI
		// empty roi manager
		selectWindow("ROI Manager");
		run("Close");
		// repeat for red image
		selectWindow("C2-"+title);
		run("Duplicate...", " ");
		rename("red");
		run("Gaussian Blur...", "sigma=1");
		run("Subtract Background...", "rolling=50");
		setAutoThreshold("Yen dark");
		setThreshold(20, 65535);
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Analyze Particles...", "include add");
		close("red");
		// select all ROI and combine them
		count=roiManager("count");
		
		if (count > 1) {
			array=newArray(count);
			for(i=0; i<count;i++) {
        			array[i] = i;
			}
			roiManager("Select", array);
			roiManager("Combine"); // merge into one roi
			roiManager("Add");
			roiManager("Select", array);
			roiManager("Delete");
		} 
		
		selectWindow("C2-"+title);
		roiManager("Select", 0);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside"); // clear all grey values outside the threshhold ROI
		// empty roi manager
		selectWindow("ROI Manager");
		run("Close");		

		// merge
		run("Merge Channels...", "c2=C1-"+title+" c6=C2-"+title+" create");
		saveAs("Tiff", newDir+name+"_merged.tiff");
		run("Close");
	}
}