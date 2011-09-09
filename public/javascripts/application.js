function initialize_beer_map(lat, lng) {
  var latlng = new google.maps.LatLng(lat, lng);
  var map    = new google.maps.Map(document.getElementById("beer_map"), {zoom: 12, center: latlng, mapTypeId: google.maps.MapTypeId.ROADMAP});
  for (var i = 0; i < 101 ; i++) {
    var bar = NEARBY_BARS[i];
    if (typeof(bar) == 'undefined') { break; }
    var barlatlng = new google.maps.LatLng(bar.coordinates[1], bar.coordinates[0]);
    var marker = new google.maps.Marker({position: barlatlng, title: bar.name, map: map});
  }
}
