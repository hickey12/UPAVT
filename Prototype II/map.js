// Name: map.js
// Written by: Max Ackley

var map;
var latlng;

function initialize() {
	//Hard coded coordinate center of Oregon
	latlng = new google.maps.LatLng(44.000718, -120.429382)

    var options = {
        zoom: 6,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map"), options);  
}
