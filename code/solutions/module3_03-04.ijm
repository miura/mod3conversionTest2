// Input: 
// - ROI Manager with nuclei selection
// - C1-Small.tif, C2-Small.tif, C3-Small.tif and C4-Small.tif opened
// Output: 
// - Overlay of detected spots (channel colored)
// - Nuclei selection with color based on spot content

roiManager("Associate", "true");
NbNuclei = roiManager("count");

// FISH spots detection
NbSpotsChan1 = newArray(NbNuclei);
NbSpotsChan2 = newArray(NbNuclei);
NbSpotsChan3 = newArray(NbNuclei);
for(i=1;i<4;i++)
{	
	// Pre-filtering
	selectImage("C"+d2s(i+1,0)+"-Small.tif");
	run("FeatureJ Laplacian", "compute smoothing=3");
	SpotLapID = getImageID();
	
	// Spot segmentation
	run("Find Maxima...", "noise=4 output=[Single Points] light");
	SpotCandMaskID = getImageID();
	
	// Cleanup
	selectImage(SpotLapID);	
	close();

	// Spot count in each nucleus
	selectImage(SpotCandMaskID);
	for(j=0;j<NbNuclei;j++)
	{
		roiManager("select",j);
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		NbSpots = histogram[255];
		if(i==1)NbSpotsChan1[j] = NbSpots;
		if(i==2)NbSpotsChan2[j] = NbSpots;
		if(i==3)NbSpotsChan3[j] = NbSpots;
	}
		
	// Spots overlay
	setThreshold(1,255);
	run("Create Selection");
	
	//Check if selection
	if(selectionType>-1)
	{
		run("Enlarge...", "enlarge=1 pixel");
		roiManager("add");
		roiManager("select",roiManager("count")-1);
		if(i==1)roiManager("Set Color", "red");
		if(i==2)roiManager("Set Color", "green");
		if(i==3)roiManager("Set Color", "blue");
		roiManager("Deselect");
	}
	selectImage(SpotCandMaskID);
	close();
}
	
// Draw color coded outlines of the nuclei
selectImage("C1-Small.tif");
for(j=0;j<NbNuclei;j++)
{
	roiManager("select",j);
	ColorCode = "FF"+toHex(63+64*NbSpotsChan1[j])+toHex(63+64*NbSpotsChan2[j])+toHex(63+64*NbSpotsChan3[j]);
	run("Properties... ", "name=Nuc"+d2s(j,0)+" stroke="+ColorCode+" width=1 fill=none");
	roiManager("update");
}
run("Images to Stack", "name=Stack title=[] use");
roiManager("Show All without labels");

// Associate spots to slice
for(j=2;j<=4;j++)
{
	roiManager("select",roiManager("count")-5+j);
	setSlice(j);
	roiManager("update");
}
setSlice(1)
roiManager("Show All without labels");