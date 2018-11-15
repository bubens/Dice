module Main exposing (..)

import Html exposing (Html)
import Html
import Html.Events as Events
import Dice


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            let
                x =
                    model.face
            in
                ( Dice.roll ((x % 6) + 1) model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        [ Events.onClick Roll
        ]
        [ Dice.toSVG model
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
