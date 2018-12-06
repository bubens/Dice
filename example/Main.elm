module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Debug exposing (log, toString)
import Dice
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Random



-- MODEL


type alias Model =
    Dice.Dice



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( Dice.create
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | Rolled Dice.Face
    | Hold


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        xxx =
            log ("update: " ++ toString msg)
    in
    case msg of
        Hold ->
            ( Dice.hold (not model.held) model, Cmd.none )

        Roll ->
            ( model, Random.generate Rolled Dice.generateRandomFace )

        Rolled face ->
            ( Dice.roll face model, Cmd.none )



-- VIEW


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


view : Model -> Document Msg
view model =
    { title = "Elm: bubens/dice example"
    , body =
        [ Html.h1 [] [ Html.text "bubens/dice example" ]
        , Dice.toSvg model
        , Html.div []
            [ Html.button
                [ Events.onClick Roll
                ]
                [ Html.text "Roll" ]
            , Html.button
                [ Events.onClick Hold ]
                [ Html.text "Hold" ]
            ]
        ]
    }



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
