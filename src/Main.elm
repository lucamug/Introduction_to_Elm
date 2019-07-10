module Main exposing (main)

-- 040_TYPE_SIGNATURE

import Array
import Browser
import Counter
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Html.Events exposing (onClick)
import SuperCounter
import Task
import Time



-- MODEL


type alias Model =
    { counters : List Int
    , time : Maybe Time.Posix
    , componentModel : SuperCounter.Model
    }



-- add a b  = a + b
-- add = \a b -> a + b


init : () -> ( Model, Cmd Msg )
init flags =
    let
        ( componentModel, componentCmd ) =
            SuperCounter.init flags
    in
    ( { counters = [ 0, -1000, 100, 200 ]
      , time = Nothing
      , componentModel = componentModel
      }
      -- Task.perform : (Time.Posix -> msg) -> Task Never Time.Posix -> Cmd msg
      -- Time.now : Task x Time.Posix
    , Cmd.batch
        [ Task.perform TimeNow Time.now
        , componentCmd
        ]
    )



-- UPDATE


type Msg
    = Increment Int
    | Decrement Int
    | TimeNow Time.Posix
    | DoNothing
    | ComponentMsg SuperComponent.Msg


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        TimeNow time ->
            ( { model | time = Just time }, Cmd.none )

        Increment id ->
            let
                array =
                    Array.fromList model.counters

                presentCount =
                    Maybe.withDefault 0 <| Array.get id array

                newArray =
                    Array.set id (presentCount + 1) array
            in
            ( { model | counters = Array.toList newArray }, Cmd.none )

        Decrement id ->
            let
                array =
                    Array.fromList model.counters

                presentCount =
                    Maybe.withDefault 0 <| Array.get id array

                newArray =
                    Array.set id (presentCount - 1) array
            in
            ( { model | counters = Array.toList newArray }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div []
        [ layout [] <|
            row [ spacing 20 ] <|
                List.indexedMap
                    (\id count ->
                        Counter.counterComponent (Increment id) (Decrement id) count
                    )
                    model.counters
        , SuperCounter.view model
        ]



-- [ counterComponent (Increment 0) (Decrement 0) 0 model
-- ]
-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
