
var map;

function createMap() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
            console.log(pos);
            map = new google.maps.Map(document.getElementById('map'), {
                center:pos,
                zoom: 15
            });

            var request = {
                location: map.getCenter(),
                radius: 2000,
                types: ['restaurant']
            }

            var service = new google.maps.places.PlacesService(map);

            service.nearbySearch(request, callback);
        });
    } else {
        // Si la geolocalización no está disponible, muestra un error
        alert("La geolocalización no está disponible en tu navegador.");
    }
}

function callback(results, status) {
  if (status == google.maps.places.PlacesServiceStatus.OK) {
    console.log(results.length);
    for (var i = 0; i < results.length; i++) {
        console.log(results[i]);
        createMarker(results[i]);
    }
  }
}

function createMarker(place) {
  var placeLoc = place.geometry.location;
  var marker = new google.maps.Marker({
    map: map,
    position: place.geometry.location,
    title: place.name
  })
}