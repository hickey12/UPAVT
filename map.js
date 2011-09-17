// Name: map.js
// Description: Creates a map centered at Portland, OR
// in the "map" container of main.html.
// Written by: Max Ackley

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
    var latlng = new google.maps.LatLng(45.589176, -122.738235)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    var map = new google.maps.Map(document.getElementById("map"), options);  
	
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
    var latlng = new google.maps.LatLng(45.518872, -122.688986)

    var options = {
        zoom: 12,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    var map = new google.maps.Map(document.getElementById("map"), options);   
     
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
    var latlng = new google.maps.LatLng(45.454411,-122.684591)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    var map = new google.maps.Map(document.getElementById("map"), options);   
     
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
    var latlng = new google.maps.LatLng(45.502076,-122.607043)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    var map = new google.maps.Map(document.getElementById("map"), options);  
     
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
    var latlng = new google.maps.LatLng(45.486072,-122.769992)

    var options = {
        zoom: 10,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    var map = new google.maps.Map(document.getElementById("map"), options);
    
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





