// File: map.js; Authors: Max Ackley, Jace Raile, Trever Hickey; Last modified: 18 Sep 2011 @ 7:12 PM
// Adapted from original code by: Dr. Tanya Crenshaw, University of Portland

//Global variables
var map;
var latlng;

//draw_map function: randomly selects one of 5 high schools to use as center / zcta area
function draw_map(){
	var rand = Math.floor(Math.random() * 5);
	
	if (rand == 0)
		roosevelt_map();
	else if (rand == 1)
		lincoln_map();
	else if (rand == 2)
		riverdale_map();
	else if (rand == 3)
		franklin_map();
	else if (rand == 4)
		jesuit_map();	
}

//roosevelt_map function: centers the map at roosevelt high school
//and draws polygon around zcta for 97203
function roosevelt_map() {
	//set latlng to roosevelt high
    latlng = new google.maps.LatLng(45.589176, -122.738235)

	//set map options
    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    //make a new map
    map = new google.maps.Map(document.getElementById("map"), options);  
	
	//preform search
	search();
	
	//create a new marker for the high school
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Roosevelt High School, Zip Code: 97203"
    }); 
     
    //create a zipcode polygon from zcta data
    zipCodeArea = new google.maps.Polygon({
        paths: constructRooseveltZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    //set the polygon on the map
    zipCodeArea.setMap(map);
}

//FOR FUNCTIONALITY OF ALL <name>_map() FUNCTIONS PAST THIS POINT,
//REFER BACK TO THE ABOVE FUNCTION: roosevelt_map().

//lincoln_map function: centers the map at lincoln high school
//and draws polygon around zcta for 97205
function lincoln_map() {
    latlng = new google.maps.LatLng(45.518872, -122.688986)

    var options = {
        zoom: 12,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);   
     
    search(); 
	
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Lincoln High School, Zip Code: 97205"
    });
    
    zipCodeArea = new google.maps.Polygon({
        paths: constructLincolnZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
}

//riverdale_map function: centers the map at riverdale high school
//and draws polygon around zcta for 97219
function riverdale_map() {
    latlng = new google.maps.LatLng(45.454411,-122.684591)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);   
     
    search(); 
	
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Riverdale High School, Zip Code: 97219"
    });
    
    zipCodeArea = new google.maps.Polygon({
        paths: constructRiverdaleZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
}

//franklin_map function: centers the map at franklin high school
//and draws polygon around zcta for 97206
function franklin_map() {
    latlng = new google.maps.LatLng(45.502076,-122.607043)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);  
     
    search();
	
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Franklin High School, Zip Code: 97206"
    }); 
    
    zipCodeArea = new google.maps.Polygon({
        paths: constructFranklinZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
}

//jesuit_map function: centers the map at jesuit high school
//and draws polygon around zcta for 97225
function jesuit_map() {
    latlng = new google.maps.LatLng(45.486072,-122.769992)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);
    
    search();
    
    var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Jesuit High School, Zip Code: 97225"
    });
    
    zipCodeArea = new google.maps.Polygon({
        paths: constructJesuitZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
}

//search function: searches for lodging in a 5000 meter radius from
//the map's center (a specific high school) and marks the results
function search()
{
	//set the search terms; set key to own GOOGLE API key for commercial use 
	var searchTerms = {
		location: latlng,
		radius: 5000,
		types: ['lodging'], 
		name: "hotel",
		sensor: false,
		key: "AIzaSyAy0ZwTIC99i-qi15Bv8OrdS7nwAeZm1LU"
		};
	
	//Gets the search service using Places library
	var service = new google.maps.places.PlacesService(map);
	service.search(searchTerms, callback);
}

//callback fucntion: necessray for google maps/places API to return search results
function callback(results, status) 
{
	//Check if the search was okay
	if(status == google.maps.places.PlacesServiceStatus.OK) 
	{
		//Iterates through the search.
		for(var i = 0; i < results.length; i++) 
		{
			createMarker(results[i]);
		}
	}
	else if(status == google.maps.places.PlacesServiceStatus.ERROR)
	{
		document.getElementById("DEBUG AREA").innerHTML="ERROR";
	}
	else if(status == google.maps.places.PlacesServiceStatus.INVALID_REQUEST)
	{
		document.getElementById("DEBUG AREA").innerHTML="INVALID_REQUEST";
	}
	else if(status == google.maps.places.PlacesServiceStatus.OVER_QUERY_LIMIT)
	{
		document.getElementById("DEBUG AREA").innerHTML="OVER_QUERY_LIMIT";
	}
	else if(status == google.maps.places.PlacesServiceStatus.REQUEST_DENIED)
	{
		document.getElementById("DEBUG AREA").innerHTML="REQUEST_DENIED";
	}
	else if(status == google.maps.places.PlacesServiceStatus.UNKNOWN_ERROR)
	{
		document.getElementById("DEBUG AREA").innerHTML="UNKNOWN_ERROR";
	}
	else if(status == google.maps.places.PlacesServiceStatus.ZERO_RESULTS)
	{
		document.getElementById("DEBUG AREA").innerHTML="ZERO_RESULTS";
	}
}

//createMarker function: creates a marker for a place (returned by search)
function createMarker(place) {
        var marker = new google.maps.Marker({
          map: map,
          position: place.geometry.location,
          title: place.name
        });
        
      }

