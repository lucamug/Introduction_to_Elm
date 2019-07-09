module Main exposing (main)

-- 040_TYPE_SIGNATURE

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Iso8601
import Task
import Time



-- MODEL


type alias Model =
    { count : Int
    , posixStart : Maybe Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    -- Time.now : Task x Time.Posix
    -- Task.perform : (a -> msg) -> Task Never a -> Cmd msg
    -- with a = Time.Posix
    -- Task.perform : (Time.Posix -> msg) -> Task Never Time.Posix -> Cmd msg
    ( { count = 0, posixStart = Nothing }, Task.perform TimeNow Time.now )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | TimeNow Time.Posix


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        TimeNow posix ->
            ( { model | posixStart = Just posix }, Cmd.none )

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
        , div [] [ text <| Debug.toString model ]
        , div []
            [ text <|
                case model.posixStart of
                    Just posix ->
                        Iso8601.fromTime posix

                    Nothing ->
                        ""
            ]
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
