// FILE: map.js
// AUTHOR: Max Ackley
// MODIFIED: 16 October 2011
//
// DESCRIPTION: This file currently handles the drawing
// of a Google map, the parsing of data from .csv files
// and using that to draw polygons on the map.
// 
// Beware the callbacks!


function initialize(){
	
    //Hard coded coordinate center of Oregon
    var latlng = new google.maps.LatLng(44.000718, -120.429382)
    var map;
    
    //Settings for the map
    var options = {
        zoom: 6,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
	var settings = getValues(document.thisForm);
	
    //Assign values to specify data (will be a function, passed in)
    var year = settings['year'];
	var group = settings['group'];
    var state = "OR";
    var path = "./dataParsing/schoolData/summary_" + state + "_" + year + ".csv";
	
    //Populate an array of the zips with data, and an array of the data itself
    d3.csv(path, function(rows){
    	//Draw the map
   		map = new google.maps.Map(document.getElementById("map"), options);

		var relevantZips = new Array();
        var relevantData = new Array();
		
		switch (group)
		{
			case "Inquiries":     
		        rows.forEach(function(r){
		            r.Inquiries = parseInt(r.Inquiries);
		            r.Zipcodes = parseInt(r.Zipcodes);
		            
		            if (r.Inquiries != 0) {
		                relevantZips.push(r.Zipcodes);
		                relevantData.push(r.Inquiries);
		            }
		        });
				break;
				
			case "Applied":
		        rows.forEach(function(r){
		            r.Applied = parseInt(r.Applied);
		            r.Zipcodes = parseInt(r.Zipcodes);
		            
		            if (r.Applied != 0) {
		                relevantZips.push(r.Zipcodes);
		                relevantData.push(r.Applied);
		            }
		        });
				break;
			
			case "Accepted":
		        rows.forEach(function(r){
		            r.Accepted = parseInt(r.Accepted);
		            r.Zipcodes = parseInt(r.Zipcodes);
		            
		            if (r.Accepted != 0) {
		                relevantZips.push(r.Zipcodes);
		                relevantData.push(r.Accepted);
		            }
		        });
				break;
				
			case "Enrolled":
		        rows.forEach(function(r){
		            r.Enrolled = parseInt(r.Enrolled);
		            r.Zipcodes = parseInt(r.Zipcodes);
		            
		            if (r.Enrolled != 0) {
		                relevantZips.push(r.Zipcodes);
		                relevantData.push(r.Enrolled);
		            }
		        });
				break;
				
			default:
				document.write("Error!!");
		}
		
        //Grab the max and min of the data to calculate shading scale
        var min = d3.min(relevantData);
        var max = d3.max(relevantData);
		
        //Draw all the polygons for each zip code, shading them appropriately
        var i;
        for (i = 0; i < relevantZips.length; i++) {
			let j = i; //Only supported in Javascript 1.7
			
			var path2 = "./zipParsing/Zipcodes/zip" + relevantZips[i] + ".csv";

		    //Grab all the pairs of Lat-Lon from the data file
		    d3.csv(path2, function(data) {
	    
				//Each boundary characterizes a polygon
		   		var boundariesArray = new Array();
				
				//Points within a single boundary
		        var pointArray = new Array();
				
				data.forEach(function(r){
					if (r.LAT != "END") {
		            	//If we're not at the end, keep adding points to array
		            	var point = new google.maps.LatLng(parseFloat(r.LAT), parseFloat(r.LON));
		           		pointArray.push(point);
		        	}
		        	else {
		            	//If at the end set of points, add set to array and start new one
		            	boundariesArray.push(pointArray);
		            	pointArray = new Array();
		        	}
		        });
		        
				//Returns a value between 0.0 and 1.0
            	var shadeScale = (relevantData[j] - min) / (max - min);
  				
  				var k;
            	for (k = 0; k < boundariesArray.length; k++)
            	{
                	//Create the polygon objects
                	var zipCodeArea = new google.maps.Polygon({
	                    paths: boundariesArray[k],
	                    strokeColor: "#5f00aa", 
	                    strokeOpacity: 0.8,
	                    strokeWeight: 1,
	                    fillColor: "#5f00aa", 
	                    fillOpacity: 0.1 + (shadeScale * 0.8), //Opacity: .1-.9
	                });
					
					google.maps.event.addListener(zipCodeArea, 'click', function(event) {       
                        alert("Zipcode: " + relevantZips[j] + "\n" + settings['group'] + ": " + relevantData[j]); 
        			});

	                //Set the polygon on the map
	                zipCodeArea.setMap(map);
				}
            });	
        }	
    });
}
