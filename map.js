// FILE: map.js
// AUTHOR: Max Ackley
// MODIFIED: 16 October 2011
//
// DESCRIPTION: This file handles the drawing of a
// Google map, the parsing of data from .csv files
// and using that to draw polygons on the map.
// 
// Beware the callbacks!


// Description: Initializes the map settings, draws the map, and sets data
// visualization into motion. Called when the page is loaded or after a 
// form is submitted.
function init_map(){
	//Retrieves an associative array with the current form values
	var settings = getFormValues(document.thisForm);
	
    //Options to initialize map
  	var options = getMapOptions(settings['location']);

    //Draw the map
    var map = new google.maps.Map(document.getElementById("map"), options);

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
    var path = getPath(settings);
	
	//Access admissions data for each zip code
    d3.csv(path, function(data){
		var relevantZips = new Array();
        var relevantData = new Array();
        
        //Populate arrays of zips and data with information relevant to group
        populateDataArrays(data, settings['group'], relevantZips, relevantData);
       
        //Draw all the polygons for each zip code, shading them appropriately
        var i;
        for (i = 0; i < relevantZips.length; i++) {
        	
        	//i is gone at time of callback so make j local
			let j = i; //Only supported in Javascript 1.7
			
			//If any zip codes have less than 5-digits, add back leading 0's
			//that have been removed in data parsing  
			while (relevantZips[i].toString().length < 5) {
				relevantZips[i] = "0" + relevantZips[i];
			}
			
			var path2 = "./zipcodeParsing/" + settings['location'] + "/Zipcodes/zip" + relevantZips[i] + ".csv";
			
		    //Access all the pairs of Latitude-Longitude from the data file
		    d3.csv(path2, function(rows) {
		    	//Check that the data for the zip code exists before drawing it
	    		if (rows != null)
	    		{
					//Each boundary characterizes a polygon 
					//(zip codes may have multiple boundaries)
			   		var boundaries = new Array();
					
					//Parse zip boundaries from coordinates and populate array
					parseZipBoundaries(rows, boundaries);
					
					//Grab max and min of data to calculate shading scale
	       			var min = d3.min(relevantData);
	        		var max = d3.max(relevantData);
			
			
					//Yields a ratio between 0.0 and 1.0, accounting for 
					//the case where min = max data.
					var shadeScale;
					if (max - min != 0) {
						shadeScale = (relevantData[j] - min) / (max - min);
					}
					else {
						shadeScale = 1.0;
					}
	
					//Creates polygons from boundaries and draws them on the map
	  				drawBoundaries(map, settings, boundaries, 
	  					relevantZips[j], relevantData[j], shadeScale);
	  			}
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
		case "Inquiry":     
	        rows.forEach(function(r){
	            r.Inquiry = parseInt(r.Inquiry);
	            r.Zipcodes = parseInt(r.Zipcodes);
	            
	            //If zipcode data is not 0, add it to be drawn
	            if (r.Inquiry != 0) {
	                zipsArray.push(r.Zipcodes);
	                dataArray.push(r.Inquiry);
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
function drawBoundaries(map, settings, boundariesArray, zip, value, shadeScale) {
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


// Description: Provides options to center a Google Map and zoom in on the
// selected state. Returns an associative array that the Google Maps API
// uses to create the map.
function getMapOptions(state) {
	switch (state)
	{
		case "US":
			return {
				zoom: 3,
			    center: new google.maps.LatLng(39.977120, -98.067627),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
	
		case "AL": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(32.841667, -86.633333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
	
		case "AK": 
			return {
				zoom: 3,
			    center: new google.maps.LatLng(64.731667, -152.470000),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
	
		case "AZ": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(34.308333, -111.793333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
	
		case "AR": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(34.815000, -92.301667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "CA": 
			return {
				zoom: 5,
			    center: new google.maps.LatLng(36.965000, -120.081667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "CO": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(38.998333, -105.641667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "CT": 
			return {
				zoom: 8,
			    center: new google.maps.LatLng(41.595000, -72.706667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
			
		case "DC":
			return {
				zoom: 11,
				center: new google.maps.LatLng(38.93885, -77.035847),
				mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "DE": 
			return {
				zoom: 8,
			    center: new google.maps.LatLng(39.181175,-75.385895),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "FL": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(28.062286,-83.300171),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "GA": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(32.713333, -83.495000),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;	
		
		case "HI": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(20.951667, -157.27667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "ID": 
			return {
				zoom: 5,
			    center: new google.maps.LatLng(45.367584, -114.239502),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "IL": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(40.013333, -89.306667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "IN": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(39.895000, -86.266667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "IA": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(41.961667, -93.385000),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "KS": 
			return {
			
				zoom: 6,
			    center: new google.maps.LatLng(38.498333, -98.698333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "KY": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(37.358333, -85.506667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "LA": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(30.968333, -92.536667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "ME": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(45.253333, -69.233333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "MD": 
			return {
				zoom: 7,
			    center: new google.maps.LatLng(39.219487, -76.993103),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "MA": 
			return {
				zoom: 7,
			    center: new google.maps.LatLng(42.340000, -72.031667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "MI": 
			return {
				zoom: 5,
			    center: new google.maps.LatLng(45.061667, -84.938333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "MN": 
			return {
				zoom: 5,
			    center: new google.maps.LatLng(46.025000, -95.326667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "MS": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(32.815000, -89.938333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "MO": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(38.495000, -92.631667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "MT": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(47.031667, -109.638333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "NE": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(41.525000, -99.861667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "NV": 
			return {
				zoom: 5,
			    center: new google.maps.LatLng(39.505000, -116.931667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "NH": 
			return {
				zoom: 7,
			    center: new google.maps.LatLng(43.641667, -71.571667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "NJ": 
			return {
				zoom: 7,
			    center: new google.maps.LatLng(40.070000, -74.558333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "NM": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(34.501667, -106.111667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "NY": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(42.965000, -76.016667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "NC": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(35.603333, -79.455000),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "ND": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(47.411667, -100.568333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "OH": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(40.361667, -82.741667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "OK": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(35.536667, -97.660000),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "OR": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(43.868333, -120.978333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "PA": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(40.896667, -77.746667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "RI": 
			return {
				zoom: 8,
			    center: new google.maps.LatLng(41.671667, -71.576667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "SC": 
			return {
				zoom: 7,
			    center: new google.maps.LatLng(33.830000, -80.873333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "SD": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(44.401667, -100.478333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "TN": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(35.795000, -86.621667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "TX": 
			return {
				zoom: 5,
			    center: new google.maps.LatLng(31.243333, -99.458333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "UT": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(39.386667, -111.685000),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "VT": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(43.926667, -72.671667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "VA": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(37.488333, -78.563333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "WA": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(47.333333, -120.268333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "WV": 
			return {
				zoom: 7,
			    center: new google.maps.LatLng(38.598333, -80.703333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "WI": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(44.433333, -89.763333),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
		
		case "WY": 
			return {
				zoom: 6,
			    center: new google.maps.LatLng(42.971667, -107.671667),
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			break;
			
		default:
			break;
			
	}
}
