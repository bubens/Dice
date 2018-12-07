module Dice exposing
    ( Dice, Face
    , create
    , roll, rollTo, hold, generateRandomFace, toInt
    , toSvg
    )

{-| This module is a small helper to create, handle and visualize a Dice.


# Definition

@docs Dice, Face


# Create

@docs create


# Handle

@docs roll, rollTo, hold, generateRandomFace, toInt


# Visualize

@docs toSvg

-}

import Array
import Html
import Maybe
import Random
import Svg
import Svg.Attributes as Attributes


{-| Unitype for faces of a dice.
Export only to be used for type-decleration (e.g. Dice.generateRandomFace)
-}
type Face
    = One
    | Two
    | Three
    | Four
    | Five
    | Six


{-| Definition of a Type Dice.

    Dice 1 False

-}
type alias Dice =
    { face : Face
    , held : Bool
    }


{-| Generator for random rolls.
Generates a random face of the type Face.

    update : Msg -> Model -> ( Model, Msg )
    update msg model =
        case msg of
            RollDice ->
                ( model, Random.generate DiceRolled generateRandomFace )

            DiceRolled face ->
                ( Dice.roll face, Cmd.none )

-}
generateRandomFace : Random.Generator Face
generateRandomFace =
    Random.uniform One [ Two, Three, Four, Five, Six ]


{-| Create a Dice with a predefined face.
A newly created Dice will not be held.

    Dice.create

    -- -> { face = None, held = False } : Dice.Dice

-}
create : Dice
create =
    Dice One False


{-| Roll a dice.
Will only if the dice is not currently held.

    Dice.create
        |> roll Two
    -- -> { face = Dice.Two, held = False } : Dice.Dice

-}
roll : Face -> Dice -> Dice
roll newFace dice =
    if dice.held == False then
        { dice | face = newFace }

    else
        dice


{-| Roll the dice to a certain face.
Specify newFace by Int. Returns Nothing if newFace is not a valid face.

    create
        |> rollTo 2
        |> Maybe.withDefault "Error"

-}
rollTo : Dice -> Int -> Maybe Dice
rollTo dice newFace =
    case newFace of
        1 ->
            Just (roll One dice)

        2 ->
            Just (roll Two dice)

        3 ->
            Just (roll Three dice)

        4 ->
            Just (roll Four dice)

        5 ->
            Just (roll Five dice)

        6 ->
            Just (roll Six dice)

        _ ->
            Nothing


{-| Hold a dice.
A held dice will not roll.

    Dice.create
        |> roll Six
        |> hold True
    -- -> { face = , held = True } : Dice.Dice

-}
hold : Bool -> Dice -> Dice
hold isHeld dice =
    { dice | held = isHeld }


{-| Get dice as Int.
Returns current face of dice as int.

    Dice.create
        |> roll Two
        |> asInt
    -- -> 2 : Int

-}
toInt : Dice -> Int
toInt dice =
    case dice.face of
        One ->
            1

        Two ->
            2

        Three ->
            3

        Four ->
            4

        Five ->
            5

        Six ->
            6


{-| Get a visual representation of the dice as SVG

    Dice.create
        |> roll Four
        |> toSvg
    -- -> <internals> : Html msg

-}
toSvg : Dice -> Html.Html msg
toSvg dice =
    getRequiredDots dice.face
        |> createFaceSvg dice.held


getRequiredDots : Face -> List Int
getRequiredDots face =
    case face of
        One ->
            [ 3 ]

        Two ->
            [ 5, 1 ]

        Three ->
            [ 5, 3, 1 ]

        Four ->
            [ 0, 1, 5, 6 ]

        Five ->
            [ 0, 1, 3, 5, 6 ]

        Six ->
            [ 0, 1, 2, 4, 5, 6 ]


createFaceSvg : Bool -> List Int -> Html.Html msg
createFaceSvg held dots =
    createDotsSvg dots
        |> (::)
            (Svg.rect
                [ Attributes.width "100"
                , Attributes.height "100"
                , Attributes.x "0"
                , Attributes.y "0"
                , Attributes.fill (getBgColor held)
                ]
                []
            )
        |> Svg.svg
            [ Attributes.width "100"
            , Attributes.height "100"
            , Attributes.viewBox "0 0 100 100"
            , Attributes.style "border: solid 1px #000000; border-radius: 10px"
            ]


createDotsSvg : List Int -> List (Svg.Svg msg)
createDotsSvg dots =
    dots
        |> List.map (\x -> getDotCoords x)
        |> List.map toCircleSvg


getDotCoords : Int -> ( Int, Int )
getDotCoords position =
    case position of
        0 ->
            ( 20, 20 )

        1 ->
            ( 80, 20 )

        2 ->
            ( 20, 50 )

        3 ->
            ( 50, 50 )

        4 ->
            ( 80, 50 )

        5 ->
            ( 20, 80 )

        6 ->
            ( 80, 80 )

        _ ->
            ( 0, 0 )


toCircleSvg : ( Int, Int ) -> Svg.Svg msg
toCircleSvg ( pcx, pcy ) =
    Svg.circle
        [ Attributes.cx (String.fromInt pcx)
        , Attributes.cy (String.fromInt pcy)
        , Attributes.r "10"
        , Attributes.fill "#000000"
        ]
        []


getBgColor : Bool -> String
getBgColor held =
    if held == True then
        "#787878"

    else
        "#FFFFFF"
