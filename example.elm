module Main exposing (..)

import Html exposing (Html)
import Html
import Html.Events as Events
import Html.Attributes as Attributes
import Dice
import Random


-- MODEL


type alias Model =
    Dice.Dice



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Dice.create 1
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | Rolled Int
    | Hold


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Hold ->
            ( Dice.hold (not model.held) model, Cmd.none )

        Roll ->
            ( model, Random.generate Rolled (Random.int 1 6) )

        Rolled face ->
            ( Dice.roll face model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        [ Attributes.style [ ( "border", "1px solid #000" ) ]
        , Attributes.width 100
        ]
        [ Dice.toSVG model
        , Html.button
            [ Events.onClick Roll
            ]
            [ Html.text "Roll" ]
        , Html.button
            [ Events.onClick Hold ]
            [ Html.text "Hold" ]
        ]



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
