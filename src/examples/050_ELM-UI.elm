module Main exposing (main)

-- 050_ELM-UI

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



-- UPDATE (CONTROLLER)


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


view : Model -> Html Msg
view model =
    layout [] <|
        column []
            [ Input.button []
                { onPress = Just Increment
                , label = text "+1"
                }
            , el [] <|
                text (String.fromInt model.count)
            , Input.button []
                { onPress = Just Decrement
                , label = text "-1"
                }
            ]



-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
