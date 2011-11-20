// FILE: chart.js
// AUTHOR: Max Ackley
// MODIFIED: 19 November 2011
//
// DESCRIPTION: This file currently handles the 
// parsing of data from .csv files and using that
// to create a chart from HTML objects.


// Description: 
function init_chart() {
	//Make selection of bars container to append bar divs with d3
	var bar = d3.select("body")
				.select(".chart")
				.select("#bars")
				.append("div")
				.attr("class", "bar");
	
	//Make selection of label container to append label divs with d3
	var barLabel = d3.select("body")
					 .select(".chart")
					 .select("#labels")
					 .append("div")
					 .attr("class", "barLabel");
	
	//Get the settings from the form on the HTML page
	var settings = getFormValues(document.thisForm);

	//Get the path based on the chosen form settings
	var path = getPath(settings); //getPath is included in formReader.js
	
	d3.csv(path, function(rows){
		var topZips = new Array();
		var relevantData = new Array();
		
		//Populate the arrays with zip and enrollment data
		populateChartArrays(rows, settings['group'], topZips, relevantData);
		
		//Set the bar widths to be even spaced within its container (490px wide)
		var w = (490 / topZips.length) + "px";
		
		//Use d3 to dynamically scale bar height based on data range
		var h = d3.scale
			      .linear()
			      .domain([0, relevantData[0]])
			      .range(["0px", "140px"]);

		//Append bar divs to HTML document using d3
		bar.selectAll("div")
		   .data(relevantData)
		   .enter().append("div")
		   .style("width", w)
		   .style("height", h)
		   .style("margin-top", function(d){
		   		//Set the top margin based on bar size so that bars line up
		   		return (155 - parseFloat(h(d).substring(0, h(d).length - 2))) + "px";
		   })
		   .text(function(d) { return d; });
		
		//If any zip codes have less than 5-digits, add back leading 0's
		//that have been removed in data parsing  
		var i;   
		for (i = 0; i < topZips.length; i++) {
			if (topZips[i].toString().length != 0) {
				while (topZips[i].toString().length < 5) {
					topZips[i] = "0" + topZips[i];
				}
			}
		}
		
		//Append label divs to HTML document using d3
		barLabel.selectAll("div")
				.data(topZips)
				.enter().append("div")
				.text(function(d){
				    return d;
				})
				.style("width", w)
				.style("margin-left", "1px")
				.style("margin-right", "1px");
	});
}

// Description: Given rows of zip codes and related info, parse out the desired
// fields and populate an array with the data and an array with those zip codes.
function populateChartArrays(rows, group, topZips, relevantData) {
	//Find the zipcodes with the top 5 values to graph
	var i;
	switch (group) {
		case "Inquiry":
			for (i = 0; i < 5; i++) {
				//Reinitialize vars for keeping track of maximum
				var maxData = 0;
				var maxZip = "";
				
				//Go through each row and find the maximum and associated zip
				rows.forEach(function(r){
					if (r.Zipcodes != "" && parseInt(r.Inquiry) > maxData 
							&& !contains(r.Zipcodes, topZips)) {
						maxZip = r.Zipcodes;
						maxData = r.Inquiry;
					}
				});
				
				topZips.push(maxZip);
				relevantData.push(maxData);
				
	
			}
			break;
			
		case "Applied":
			for (i = 0; i < 5; i++) {
				//Reinitialize vars for keeping track of maximum
				var maxData = 0;
				var maxZip = "";
				
				//Go through each row and find the maximum and associated zip
				rows.forEach(function(r){
					if (r.Zipcodes != "" && parseInt(r.Applied) > maxData 
							&& !contains(r.Zipcodes, topZips)) {
						maxZip = r.Zipcodes;
						maxData = r.Applied;
					}
				});
				
				topZips.push(maxZip);
				relevantData.push(maxData);
			}
			break;
			
		case "Accepted":
			for (i = 0; i < 5; i++) {
				//Reinitialize vars for keeping track of maximum
				var maxData = 0;
				var maxZip = "";
				
				//Go through each row and find the maximum and associated zip
				rows.forEach(function(r){
					if (r.Zipcodes != "" && parseInt(r.Accepted) > maxData 
							&& !contains(r.Zipcodes, topZips)) {
						maxZip = r.Zipcodes;
						maxData = r.Accepted;
					}
				});
				
				topZips.push(maxZip);
				relevantData.push(maxData);
			}
			break;
			
		case "Enrolled":
			for (i = 0; i < 5; i++) {
				//Reinitialize vars for keeping track of maximum
				var maxData = 0;
				var maxZip = "";
				
				//Go through each row and find the maximum and associated zip
				rows.forEach(function(r){
					if (r.Zipcodes != "" && parseInt(r.Enrolled) > maxData 
							&& !contains(r.Zipcodes, topZips)) {
						maxZip = r.Zipcodes;
						maxData = r.Enrolled;
					}
				});
				
				topZips.push(maxZip);
				relevantData.push(maxData);
			}
			break;
	
		default:
	}
}

// Description: A helper function to determine if an array 
// contains a particular element.
function contains(element, array) {
	var i;
	for (i = 0; i < array.length; i++) {
		if (array[i] == element) {
			return true;
		}
	}
	
	return false;	
}
