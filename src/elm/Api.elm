module Api exposing (fetchPlace, fetchSuggestions)

import Http
import Json.Decode exposing (Decoder, at, field, float, list, string, succeed)
import Json.Decode.Pipeline as Pipeline exposing (custom, decode, required, resolve)
import Types exposing (Location, Place, Suggestion, Suggestions)


placeDecoder : Decoder Place
placeDecoder =
    let
        toPlace formatted_address location =
            succeed <| Place formatted_address location

        rawDecoder =
            decode toPlace
                |> required "formatted_address" string
                |> custom (at [ "geometry", "location" ] locationDecoder)
                |> resolve
    in
    at [ "result" ] rawDecoder


locationDecoder : Decoder Location
locationDecoder =
    decode Location
        |> required "lat" float
        |> required "lng" float


suggestionsDecoder : Decoder Suggestions
suggestionsDecoder =
    at [ "predictions" ] <| list suggestionDecoder


suggestionDecoder : Decoder Suggestion
suggestionDecoder =
    let
        toSuggestion description place_id =
            succeed <| Suggestion description place_id
    in
    decode toSuggestion
        |> required "description" string
        |> required "place_id" string
        |> resolve


getUrl : String
getUrl =
    "https://maps.googleapis.com/maps/api/place/"


fetchPlace : String -> String -> Http.Request Place
fetchPlace gmapsApiKey id =
    let
        url =
            getUrl ++ "details/json?placeid=" ++ id ++ "&key=" ++ gmapsApiKey
    in
    Http.get url placeDecoder


fetchSuggestions : String -> String -> Http.Request Suggestions
fetchSuggestions gmapsApiKey input =
    let
        url =
            getUrl ++ "autocomplete/json?input=" ++ input ++ "&key=" ++ gmapsApiKey
    in
    Http.get url suggestionsDecoder
