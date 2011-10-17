// FILE: map.js
// AUTHOR: Max Ackley
// MODIFIED: 16 October 2011
//
// DESCRIPTION: This file currently handles the drawing
// of a Google map, the parsing of data from .csv files
// and using that to draw polygons on the map.
// 
// Beware the callbacks!


// Description: Initializes the map settings, draws the map, and sets data
// visualization into motion. Called when the page is loaded or after a 
// form is submitted.
function initialize(){
	
	//Hard-coded coordinate center of Oregon
    var latlng = new google.maps.LatLng(44.000718, -120.429382);//getMapCenter();
    
    //Options to initialize map
  	var options = { //getMapOptions();
        zoom: 6,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    //Draw the map
    var map = new google.maps.Map(document.getElementById("map"), options);
    
 	//Retrieves an associative array with the current form values
	var settings = getFormValues(document.thisForm);

	//Visualizes data appropriate to settings from form
	visualizeData(map, settings);
}

// Description: The controller for visualization of the data. Reads in
// admissions data and zip boundaries then draws boundaries on the map 
// relevant to the data.
//
// NOTE: The nested d3.csv calls are necessary because the data is scoped 
// within each callback but each step requires access to the previous data
function visualizeData(map, settings) {	
    //Specify data to visualize based on settings
    var year = settings['year'];
	var group = settings['group'];
    var state = "OR"; //Will be retrieved from the form in alpha release
    var path = "./dataParsing/schoolData/summary_" + state + "_" + year + ".csv";
	
	//Access admissions data for each zip code
    d3.csv(path, function(data){
		var relevantZips = new Array();
        var relevantData = new Array();
        
        //Populate arrays of zips and data with information relevant to group
        populateDataArrays(data, group, relevantZips, relevantData);
       
        //Draw all the polygons for each zip code, shading them appropriately
        var i;
        for (i = 0; i < relevantZips.length; i++) {
        	
        	//i is gone at time of callback so make j local
			let j = i; //Only supported in Javascript 1.7
			
			var path2 = "./zipParsing/Zipcodes/zip" + relevantZips[i] + ".csv";

		    //Access all the pairs of Latitude-Longitude from the data file
		    d3.csv(path2, function(rows) {
	    
				//Each boundary characterizes a polygon 
				//(zip codes may have multiple boundaries)
		   		var boundaries = new Array();
				
				//Parse zip boundaries from coordinates and populate array
				parseZipBoundaries(rows, boundaries);
				
				//Grab max and min of data to calculate shading scale
       			var min = d3.min(relevantData);
        		var max = d3.max(relevantData);
		
				//Yields a ratio between 0.0 and 1.0
				var shadeScale = (relevantData[j] - min) / (max - min);

				//Creates polygons from the boundaries and draws them on the map
  				drawBoundaries(map, boundaries, 
  						relevantZips[j], relevantData[j], shadeScale);
            });	
        }	
    });
}

// Description: Given rows of zip codes and related info, parse out the desired
// fields and populate an array with the data and an array with those zip codes.
function populateDataArrays(rows, category, zipsArray, dataArray) {
	//Depending on category, parse that field from data and add to arrays
	switch (category)
	{
		case "Inquiries":     
	        rows.forEach(function(r){
	            r.Inquiries = parseInt(r.Inquiries);
	            r.Zipcodes = parseInt(r.Zipcodes);
	            
	            //If zipcode data is not 0, add it to be drawn
	            if (r.Inquiries != 0) {
	                zipsArray.push(r.Zipcodes);
	                dataArray.push(r.Inquiries);
	            }
	        });
			break;
			
		case "Applied":
	        rows.forEach(function(r){
	            r.Applied = parseInt(r.Applied);
	            r.Zipcodes = parseInt(r.Zipcodes);
	            
	            //If zipcode data is not 0, add it to be drawn
	            if (r.Applied != 0) {
	                zipsArray.push(r.Zipcodes);
	                dataArray.push(r.Applied);
	            }
	        });
			break;
		
		case "Accepted":
	        rows.forEach(function(r){
	            r.Accepted = parseInt(r.Accepted);
	            r.Zipcodes = parseInt(r.Zipcodes);
	            
	            //If zipcode data is not 0, add it to be drawn
	            if (r.Accepted != 0) {
	                zipsArray.push(r.Zipcodes);
	                dataArray.push(r.Accepted);
	            }
	        });
			break;
			
		case "Enrolled":
	        rows.forEach(function(r){
	            r.Enrolled = parseInt(r.Enrolled);
	            r.Zipcodes = parseInt(r.Zipcodes);
	            
	            //If zipcode data is not 0, add it to be drawn
	            if (r.Enrolled != 0) {
	                zipsArray.push(r.Zipcodes);
	                dataArray.push(r.Enrolled);
	            }
	        });
			break;
			
		default:
	}
}

// Description: Parse out latitude and longitude data to form boundary
// arrays used to create Google Maps polygon objects.
function parseZipBoundaries(rows, boundariesArray) {
		//Array of points within a single boundary
        var boundary = new Array();
		
		rows.forEach(function(r){
			//Check for end of a boundary
			if (r.LAT != "END") {
				var lat = parseFloat(r.LAT);
				var lon = parseFloat(r.LON);
				
            	//If we're not at the end, keep adding points to array
            	var point = new google.maps.LatLng(lat, lon);
           		boundary.push(point);
        	}
        	else {
            	//If the end of a boundary, add set to array and start new one
            	boundariesArray.push(boundary);
            	boundary = new Array();
        	}
        });
		        
}

// Description: Creates polygon objects for all the boundaries for a given zip
// and draws them on the given map. Also adds an event listener to alert the
// zip number and data when the polygon is clicked.
function drawBoundaries(map, boundariesArray, zip, value, shadeScale) {
	var i;
	for (i = 0; i < boundariesArray.length; i++)
	{
    	//Create the polygon object
    	var zipCodeArea = new google.maps.Polygon({
            paths: boundariesArray[i],
            strokeColor: "#5f00aa", 
            strokeOpacity: 0.8,
            strokeWeight: 1,
            fillColor: "#5f00aa", 
            fillOpacity: 0.1 + (shadeScale * 0.8), //Opacity: .1-.9
        });
		
		//Add listener to alert with data relevant to zip code when clicked
		google.maps.event.addListener(zipCodeArea, 'click', function(event) {       
            alert("Zipcode: " + zip + "\n" + settings['group'] + ": " + value); 
		});

        //Set the polygon on the map
        zipCodeArea.setMap(map);
	}
}
