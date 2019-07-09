module Main exposing (main)

-- 040_TYPE_SIGNATURE

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Task
import Time



-- MODEL


type alias Model =
    { count : Int }


init : () -> ( Model, Cmd Msg )
init _ =
    -- Task.perform : (a -> msg) -> Task Never a -> Cmd msg
    ( { count = 0 }, Task.perform (\_ -> TimeNow) Time.now )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | TimeNow


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        TimeNow ->
            ( model, Cmd.none )

        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Increment ] [ text "+1" ]
        , div [] [ text (String.fromInt model.count) ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
