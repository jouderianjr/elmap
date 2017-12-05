// inject bundled Elm app into div#main
var Elm = require('../elm/Main');
Elm.Main.embed(document.getElementById('main'), {
  gmapsApiKey: process.env.GMAPS_API_KEY
});
