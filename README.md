# semianalytical-model-for-sheet-flow-layer-thickness-
Code that accompanies the paper "A semianalytical model for sheet flow layer thickness with application to the swash zone (DOI: 10.1002/2014JC010378)

The Matlab code provided here accompanies the paper "A semianalytical 
model for sheet flow layer thickness with application to the swash zone" 
by Thijs Lanckriet and Jack Puleo, published in JGR Oceans (DOI: 
10.1002/2014JC010378). It is written in Matlab and distributed under an 
MIT license. 

A brief overview of the subfolders: -"sassmodel" contains all the 
functions needed for the model. "sass.m" is the function that actually 
computes the sheet flow layer thickness, the other files are 
subfunctions. -"data" contains a sample time series that can be used to 
test the code (corresponds to one of the figures in the paper). 
-"sheetflowruns_swash" contains some steering scripts. E.g. 
sheetflowmodelrun_swash.m will load the data and run the model, 
figure_sheet_swash.m will make a figure corresponding to the one in the 
paper. 

Enjoy! 

