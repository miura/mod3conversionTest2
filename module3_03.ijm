// Input: 
// - ROI Manager with nuclei selection
// - C1-Small.tif, C2-Small.tif, C3-Small.tif and C4-Small.tif opened
// Output: 
// - Spot segmentation masks of the 3 channels
// - 3 Arrays (on per channel) with spot counted in each nucleus

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
}
run("Select None");

// Display arrays with counted spots per nucleus
print("Array NbSpotsChan1:");
Array.print(NbSpotsChan1);
print("Array NbSpotsChan2:");
Array.print(NbSpotsChan2);
print("Array NbSpotsChan3:");
Array.print(NbSpotsChan3);