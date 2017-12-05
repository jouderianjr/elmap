module Styles exposing (..)


defaultHeight =
    "30px"


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
    , ( "top", defaultHeight )
    , ( "width", "400px" )
    , ( "z-index", "999" )
    ]


dropdownItem : List ( String, String )
dropdownItem =
    [ ( "height", defaultHeight ), ( "line-height", defaultHeight ) ]


activeDropdownItem : List ( String, String )
activeDropdownItem =
    dropdownItem ++ [ ( "background-color", "#BBDEFB" ) ]


inputText : List ( String, String )
inputText =
    [ ( "height", defaultHeight )
    , ( "width", "400px" )
    , ( "box-sizing", "border-box" )
    ]
