module Styles exposing (..)


type alias Styles =
    List ( String, String )


defaultHeight : String
defaultHeight =
    "30px"


dropdownWrapper : Styles
dropdownWrapper =
    [ ( "display", "flex" )
    , ( "justify-content", "center" )
    , ( "margin-top", "20px" )
    ]


dropdown : Bool -> Styles
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
    , ( "top", "50px" )
    , ( "width", "400px" )
    , ( "z-index", "999" )
    , ( "border", "1px solid #ccc" )
    , ( "border-top", "none" )
    , ( "box-sizing", "border-box" )
    ]


dropdownItem : Styles
dropdownItem =
    [ ( "height", defaultHeight )
    , ( "line-height", defaultHeight )
    , ( "border-bottom", "1px solid #ccc" )
    ]


activeDropdownItem : Styles
activeDropdownItem =
    dropdownItem ++ [ ( "background-color", "#BBDEFB" ) ]


inputText : Styles
inputText =
    [ ( "height", defaultHeight )
    , ( "width", "400px" )
    , ( "box-sizing", "border-box" )
    ]
