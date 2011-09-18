// Name: map.js
// Description: Creates a map centered at Portland, OR
// in the "map" container of main.html.
// Written by: Max Ackley

var map;
var latlng;

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

function roosevelt_map() {
    latlng = new google.maps.LatLng(45.589176, -122.738235)

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
        title:"Roosevelt High School, Zip Code: 97203"
    }); 
     
    zipCodeArea = new google.maps.Polygon({
        paths: constructRooseveltZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
}

function lincoln_map() {
    latlng = new google.maps.LatLng(45.518872, -122.688986)

    var options = {
        zoom: 12,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);   
     
    search(); 
     
    zipCodeArea = new google.maps.Polygon({
        paths: constructLincolnZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
	
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Lincoln High School, Zip Code: 97205"
    });
}

function riverdale_map() {
    latlng = new google.maps.LatLng(45.454411,-122.684591)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);   
     
    search(); 
     
    zipCodeArea = new google.maps.Polygon({
        paths: constructRiverdaleZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
	
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Riverdale High School, Zip Code: 97219"
    });
}

function franklin_map() {
    latlng = new google.maps.LatLng(45.502076,-122.607043)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);  
     
    search();
     
    zipCodeArea = new google.maps.Polygon({
        paths: constructFranklinZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
	
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Franklin High School, Zip Code: 97206"
    }); 
}

function jesuit_map() {
    latlng = new google.maps.LatLng(45.486072,-122.769992)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);
    
    search();
    
    zipCodeArea = new google.maps.Polygon({
        paths: constructJesuitZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    zipCodeArea.setMap(map);
	
	var marker = new google.maps.Marker({
        position: latlng, 
        map: map, 
        title:"Jesuit High School, Zip Code: 97225"
    });
}

/**
 *This function searches for takeaway meals in the area
 *and displays them as buttons.
 *
 * @author Trever Hickey
 */
function search()
{
	//Location variable		
	//Hardcoded location variable
	//One of two location definition options.
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

/**
 *	The callback function is necessary to perform an action when a search returns results. 
 *
 * @author Trever Hickey
 */
function callback(results, status) 
{
	//Gets the map
	//Gets the map element
	//var map = new google.maps.Map(document.getElementById("map"));
	
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

/**
 * Creates a Marker using a google place object.
 *
 * @author Trever Hickey
 */
function createMarker(place) {
        var marker = new google.maps.Marker({
          map: map,
          position: place.geometry.location,
          title: place.name
        });
        
      }

