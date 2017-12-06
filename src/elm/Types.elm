module Types exposing (..)


type alias Place =
    { address : String
    , location : Location
    }


type alias Places =
    List Place


type alias Location =
    { lat : Float, lng : Float }
