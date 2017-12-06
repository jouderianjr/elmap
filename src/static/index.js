require('./styles/main.scss');

const loadGoogleMapsAPI = require('load-google-maps-api');
const Elm = require('../elm/Main');

const loadElm = map => {
  const app = Elm.Main.embed(document.getElementById('main'), {
    gmapsApiKey: process.env.GMAPS_API_KEY
  });

  subscribeAddMarkerPorts(app, map);
};

const subscribeAddMarkerPorts = (app, map) => {
  let marker;

  app.ports.addMarker.subscribe(position => {
    marker && marker.setMap(null);

    marker = new google.maps.Marker({
      position: position,
      map: map
    });

    map.panTo(position);
  });
};

const loadMapSuccess = data => {
  // Barcelona :D
  const startPoint = { lat: 41.4040313, lng: 2.1705632 };
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 14,
    center: startPoint
  });

  loadElm(map);
};

loadGoogleMapsAPI({ key: process.env.GMAPS_API_KEY })
  .then(loadMapSuccess)
  .catch(data => console.log(data));
