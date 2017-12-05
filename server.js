require('dotenv').config();
const axios = require('axios');
const app = require('express')();

const apiKey = process.env.GMAPS_API_KEY;
const url =
  'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=';

app.get('/places', function(req, res) {
  axios.get(`${url}${req.query.q}&key=${apiKey}`).then(response => {
    console.log(response.data);
    res.send(response.data);
  });
});

app.listen(3000, function() {
  console.log('Example app listening on port 3000!');
});
