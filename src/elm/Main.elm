port module Main exposing (..)

import Api exposing (fetchPlace, fetchSuggestions)
import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onMouseDown, onMouseOver)
import Http
import Keyboard
import Styles exposing (..)
import Types exposing (Location, Place, Suggestion, Suggestions)


-- APP


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


port addMarker : Location -> Cmd msg



-- MODEL


type alias Model =
    { inputValue : String
    , suggestions : Suggestions
    , selectedIndex : Int
    , isActive : Bool
    , gmapsApiKey : String
    , err : String
    }


type alias Flags =
    { gmapsApiKey : String }


model : Model
model =
    Model "" [] 0 False "" ""


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
    | FetchSuggestions (Result Http.Error Suggestions)
    | FetchPlace (Result Http.Error Place)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        OnMouseSelection newIndex ->
            ( { model | selectedIndex = newIndex }, Cmd.none )

        FetchSuggestions (Ok suggestions) ->
            ( { model | suggestions = suggestions }, Cmd.none )

        FetchSuggestions (Err err) ->
            ( { model | err = toString err }, Cmd.none )

        FetchPlace (Ok place) ->
            ( model, addMarker place.location )

        FetchPlace (Err err) ->
            ( { model | err = toString err }, Cmd.none )

        SelectedSuggestion ->
            let
                suggestionsArray =
                    Array.fromList model.suggestions

                suggestion =
                    case Array.get model.selectedIndex suggestionsArray of
                        Just item ->
                            item

                        Nothing ->
                            Suggestion "" ""

                description =
                    suggestion.description

                command =
                    fetchPlace model.gmapsApiKey suggestion.id
                        |> Http.send FetchPlace
            in
            ( { model | inputValue = description, selectedIndex = 0, isActive = False }, command )

        OnInputTyped value ->
            let
                command =
                    if value /= "" then
                        fetchSuggestions model.gmapsApiKey value
                            |> Http.send FetchSuggestions
                    else
                        Cmd.none
            in
            ( { model | inputValue = value, isActive = value /= "" }, command )

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
        [ style Styles.dropdownWrapper ]
        [ input [ type_ "text", onInput OnInputTyped, value model.inputValue, style Styles.inputText ] []
        , renderDropdown model
        , text model.err
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


renderSuggestions : Suggestions -> Int -> List (Html Msg)
renderSuggestions suggestions selectedIndex =
    List.indexedMap
        (\index item ->
            renderSuggestion item.description index <| selectedIndex == index
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
        [ text <| String.left 50 suggestion ]
