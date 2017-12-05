module Main exposing (..)

-- component import example

import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onMouseDown, onMouseOver)
import Keyboard
import Styles exposing (..)


-- APP


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { inputValue : String
    , suggestions : List String
    , selectedIndex : Int
    , isActive : Bool
    , gmapsApiKey : String
    }


type alias Flags =
    { gmapsApiKey : String }


model : Model
model =
    Model "" [] 0 False ""


init : Flags -> ( Model, Cmd Msg )
init { gmapsApiKey } =
    ( { model | gmapsApiKey = gmapsApiKey }, Cmd.none )



-- UPDATE


type Msg
    = NoOp
    | OnInputTyped String
    | OnKeyDown Keyboard.KeyCode
    | SelectedSuggestion
    | OnMouseSelection Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OnMouseSelection newIndex ->
            ( { model | selectedIndex = newIndex }, Cmd.none )

        SelectedSuggestion ->
            let
                suggestionsArray =
                    Array.fromList model.suggestions

                suggestion =
                    case Array.get model.selectedIndex suggestionsArray of
                        Just item ->
                            item

                        Nothing ->
                            ""
            in
            ( { model | inputValue = suggestion, selectedIndex = 0, isActive = False }, Cmd.none )

        OnInputTyped value ->
            ( { model
                | inputValue = value
                , suggestions = filterSuggestions mockList value
                , isActive = True
              }
            , Cmd.none
            )

        OnKeyDown keycode ->
            case keycode of
                40 ->
                    let
                        newSelectedIndex =
                            if model.selectedIndex + 1 == List.length model.suggestions then
                                0
                            else
                                model.selectedIndex + 1
                    in
                    ( { model | selectedIndex = newSelectedIndex }, Cmd.none )

                38 ->
                    let
                        newSelectedIndex =
                            if model.selectedIndex == 0 then
                                List.length model.suggestions - 1
                            else
                                model.selectedIndex - 1
                    in
                    ( { model | selectedIndex = newSelectedIndex }, Cmd.none )

                27 ->
                    ( { model | isActive = False, selectedIndex = 0 }, Cmd.none )

                13 ->
                    update SelectedSuggestion model

                _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ input [ type_ "text", onInput OnInputTyped, value model.inputValue, style Styles.inputText ] []
        , renderDropdown model
        ]



-- Subscribe


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs OnKeyDown ]


renderDropdown : Model -> Html Msg
renderDropdown model =
    div
        [ style <| Styles.dropdown model.isActive ]
        (renderSuggestions model.suggestions model.selectedIndex)


renderSuggestions : List String -> Int -> List (Html Msg)
renderSuggestions suggestions selectedIndex =
    List.indexedMap
        (\index item ->
            renderSuggestion item index <| selectedIndex == index
        )
        suggestions


renderSuggestion : String -> Int -> Bool -> Html Msg
renderSuggestion suggestion index isSelected =
    let
        suggestionStyle =
            if isSelected then
                Styles.activeDropdownItem
            else
                Styles.dropdownItem
    in
    p
        [ style suggestionStyle
        , onMouseOver <| OnMouseSelection index
        , onMouseDown SelectedSuggestion
        ]
        [ text suggestion ]


filterSuggestions : List String -> String -> List String
filterSuggestions allData term =
    let
        lowerTerm =
            String.toLower term

        startsWith dataItem =
            dataItem
                |> String.toLower
                |> String.startsWith lowerTerm
    in
    List.filter
        startsWith
        allData


mockList : List String
mockList =
    [ "Jouderian"
    , "Joao"
    , "Jordana"
    , "Pedro"
    , "Paulo"
    ]
