module Types exposing (..)


type alias Place =
    { address : String
    , location : Location
    }


type alias Location =
    { lat : Float, lng : Float }


type alias Suggestion =
    { description : String, id : String }


type alias Suggestions =
    List Suggestion
