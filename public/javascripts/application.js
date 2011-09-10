var OPEN_WINDOW;

function initialize_beer_map(lat, lng) {
  var latlng   = new google.maps.LatLng(lat, lng);
  var map      = new google.maps.Map(document.getElementById("beer_map"), {zoom: 12, center: latlng, mapTypeId: google.maps.MapTypeId.ROADMAP});
  for (var i = 0; i < 101 ; i++) {
    bar = NEARBY_BARS[i];
    if (typeof(bar) == 'undefined') { break; }
    add_bar(bar, map, i < 5);
  }
}

function add_bar(bar, map, discount) {
  var barlatlng = new google.maps.LatLng(bar.coordinates[1], bar.coordinates[0]);

  console.log(discount);

  if (discount == true) {
    var icon = "/images/marker_green.png";
    var desc = "<p>Get a discount at " + bar.name + " if you tell 'em Lancelot Link sent you!</p>";
  } else {
    var icon = null;
    var desc = "<p>" + bar.name + "</p>";
  }
  
  var marker    = new google.maps.Marker({position: barlatlng, title: bar.name, map: map, icon: icon});
  var info      = new google.maps.InfoWindow({content: "<div class='beer_map_info'><p>" + desc + "</p></div>"});
  google.maps.event.addListener(marker, 'click', function() {
    if (typeof(OPEN_WINDOW) != 'undefined') { OPEN_WINDOW.close() };
    OPEN_WINDOW = info;
    info.open(map, marker)
  });
}
