/**
 * @author Trever Hickey
 */

//Gets the map
map = new google.maps.Map(document.getElementById("map"), options);

function search()
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

//Call back function necessary to handle search
function callback(results, status) 
{
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
