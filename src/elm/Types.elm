module Types exposing (..)


type alias Place =
    { address : String
    , name : String
    , location : Location
    }


type alias Location =
    { lat : String, lng : String }
