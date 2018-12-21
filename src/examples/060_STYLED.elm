module Main exposing (main)

-- 060_STYLED

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)



-- MODEL


type alias Model =
    { count : Int }


init : Model
init =
    { count = 0 }



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }



-- VIEW


buttonAttributes =
    [ Background.color <| rgb 0.8 0.6 1
    , Border.rounded 20
    , padding 10
    , width <| px 100
    , Font.center
    ]


view : Model -> Html Msg
view model =
    layout
        [ width fill
        , height fill
        ]
    <|
        column
            [ padding 10
            , spacing 30
            , centerY
            , centerX
            , Border.rounded 30
            , Border.width 0
            , Border.shadow
                { offset = ( 0, 0 )
                , size = 10
                , blur = 50
                , color = rgba 0 0 0 0.3
                }
            ]
            [ Input.button buttonAttributes
                { onPress = Just Increment, label = text "+1" }
            , el [ centerX ] <|
                text <|
                    String.fromInt model.count
            , Input.button buttonAttributes
                { onPress = Just Decrement, label = text "-1" }
            ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
