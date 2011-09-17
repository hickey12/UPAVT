// Name: map.js
// Description: Creates a map centered at Portland, OR
// in the "map" container of main.html.
// Written by: Max Ackley

function draw_map() {
    var latlng = new google.maps.LatLng(45.523488,-122.676222);

    var options = {
      zoom: 10,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    var map = new google.maps.Map(document.getElementById("map"), options);

    var marker = new google.maps.Marker({
      position: latlng, 
      map: map, 
      title:"Center of Portland, OR"
       });    
       
    zipCodeArea = new google.maps.Polygon({
        paths: constructZipCodeArray(),
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
    });
    
    search(map);
    
    zipCodeArea.setMap(map);
}

/**
 *This function searches for takeaway meals in the area
 *and displays them as buttons.
 *
 * @author Trever Hickey
 */
function search(map)
{
	
	//Hardcoded location variable
	//One of two location definition options.
	var searchTerms = {
		location : new google.maps.LatLng(0.456433380000000E+02, -0.122768310000000E+03),
		radius : '16000',
		types : "[meal_takeaway]"
		};
	
	//Gets the search service using Places library
	var service = new google.maps.places.PlacesService(map);
	service.search(request, callback);
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
	var map = new google.maps.Map(document.getElementById("map"));
	
	//Check if the search was okay
	if(status == google.maps.places.PlacesServiceStatus.OK) 
	{
		//Iterates through the search.
		for(var i = 0; i < results.length; i++) 
		{
			var marker = new google.maps.marker({
				position: results[i].location,
				map: map,
				title: results[i].name
				});
		}
	}
}
