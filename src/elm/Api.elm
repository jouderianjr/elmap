module Api exposing (fetchData)

import Http
import Json.Decode exposing (Decoder, at, field, float, list, string, succeed)
import Json.Decode.Pipeline as Pipeline exposing (custom, decode, required, resolve)
import Types exposing (Location, Place, Places)


placesDecoder : Decoder Places
placesDecoder =
    at [ "results" ] (list placeDecoder)


placeDecoder : Decoder Place
placeDecoder =
    let
        toPlace formatted_address location =
            succeed <| Place formatted_address location
    in
    decode toPlace
        |> required "formatted_address" string
        |> custom (at [ "geometry", "location" ] locationDecoder)
        |> resolve


locationDecoder : Decoder Location
locationDecoder =
    decode Location
        |> required "lat" float
        |> required "lng" float


getUrl : String
getUrl =
    "https://maps.googleapis.com/maps/api/geocode/json?"


fetchData : String -> String -> Http.Request Places
fetchData gmapsApiKey address =
    let
        url =
            getUrl ++ "address=" ++ address ++ "&key=" ++ gmapsApiKey
    in
    Http.get url placesDecoder
