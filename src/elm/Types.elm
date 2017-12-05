module Types exposing (..)


type alias Places =
    List Place


type alias Place =
    { name : String
    , location : Location
    }


type alias Location =
    { lat : String, lng : String }
