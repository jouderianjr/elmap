module Styles exposing (..)


dropdown : Bool -> List ( String, String )
dropdown isVisible =
    let
        display =
            if isVisible then
                "block"
            else
                "none"
    in
    [ ( "display", display )
    , ( "background-color", "white" )
    , ( "position", "fixed" )
    , ( "top", "25px" )
    , ( "width", "400px" )
    , ( "z-index", "999" )
    ]


dropdownItem : List ( String, String )
dropdownItem =
    [ ( "height", "30px" ), ( "line-height", "30px" ) ]


activeDropdownItem : List ( String, String )
activeDropdownItem =
    dropdownItem ++ [ ( "background-color", "#BBDEFB" ) ]
