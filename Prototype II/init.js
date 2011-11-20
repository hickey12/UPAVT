// FILE: init.js
// AUTHOR: Max Ackley
// MODIFIED: 15 November 2011
//
// DESCRIPTION: This file is responsible for handling the 
// intialization of the map and chart elements of the application.


// Description: This function first cleans up any previous chart  
// HTML objects, then begins a new chart and map initialization.
function initialize() {
	cleanup();
	init_map();
	init_chart();
}

// Description: Removes any bars or labels from a previous
// visualization of the chart data.
function cleanup() {
	var bars = document.getElementById("bars");
	var labels = document.getElementById("labels");

	if (bars.hasChildNodes())
	{
    	while (bars.childNodes.length >= 1 )
    	{
       		bars.removeChild(bars.firstChild);       
    	} 
	}
	
	if (labels.hasChildNodes())
	{
    	while (labels.childNodes.length >= 1 )
    	{
       		labels.removeChild(labels.firstChild);       
    	} 
	}	
}
