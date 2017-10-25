// Input: 
// - 4 channels of the FISH experiment in 4 images: C1-Small.tif, C2-Small.tif, C3-Small.tif and C4-Small.tif
// Output: 
// - Detected nuclei in ROI manager

//Segment Nuclei
selectImage("C1-Small.tif");
run("FeatureJ Laplacian", "compute smoothing=12");
getMinAndMax(min,max);
setThreshold(min,-0.05);
run("Convert to Mask");
run("Fill Holes");
for(i=0;i<2;i++)run("Dilate");

//Split Particles
run("Watershed");
rename("Mask");

//Analyze Particles and store to ROI manager
run("Analyze Particles...", "size=1000-2500 circularity=0.75-1.00 show=Nothing display exclude clear include add");
NbNuclei = roiManager("count");

selectImage("Mask");
close();
selectImage("C1-Small.tif");
roiManager("Show All");