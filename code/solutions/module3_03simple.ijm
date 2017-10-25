// Input: 
// - ROI Manager with nuclei selection
// - C1-Small.tif, C2-Small.tif, C3-Small.tif and C4-Small.tif opened
// Output: 
// - Spot segmentation masks of the 3 channels
// - 1 Arrays with spot counted in each nucleus in channel 1

NbNuclei = roiManager("count");

// FISH spots detection
NbSpotsChan1 = newArray(NbNuclei);

// Pre-filtering
selectImage("C1-Small.tif");
run("FeatureJ Laplacian", "compute smoothing=3");
SpotLapID = getImageID();
	
// Spot segmentation
run("Find Maxima...", "noise=4 output=[Single Points] light");
SpotCandMaskID = getImageID();
	
// Spot count in each nucleus
selectImage(SpotCandMaskID);
for(j=0;j<NbNuclei;j++)
{ 	
	roiManager("select",j);
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	NbSpots = histogram[255];
	NbSpotsChan1[j] = NbSpots;
}

// Display arrays with counted spots per nucleus
print("Array NbSpotsChan1:");
Array.print(NbSpotsChan1);

run("Select None");