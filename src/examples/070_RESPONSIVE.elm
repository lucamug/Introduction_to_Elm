module Main exposing (main)

-- 070_RESPONSIVE

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)



-- MODEL


type alias Model =
    { count : Int
    , width : Int
    }


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { count = 0
      , width = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | OnResize Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count + 1 }, Cmd.none )

        OnResize x y ->
            ( { model | width = x }, Cmd.none )



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
    layout [ width fill, height fill ] <|
        (if model.width < 400 then
            column

         else
            row
        )
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
                , color = rgba 0.5 0.5 0.5 0.5
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



-- SUBSCRIPTIONS


subscriptions _ =
    Browser.Events.onResize OnResize



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
