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
import Task
import Time



-- MODEL


type alias Model =
    { counters : List Int
    , time : Maybe Time.Posix
    , inputFieldContent : Int
    }



-- add a b  = a + b
-- add = \a b -> a + b


init : () -> ( Model, Cmd Msg )
init _ =
    ( { counters = [ 0, -1000, 10, 20, 30 ]
      , time = Nothing
      , inputFieldContent = 0
      }
      -- Task.perform : (Time.Posix -> msg) -> Task Never Time.Posix -> Cmd msg
      -- Time.now : Task x Time.Posix
    , Task.perform TimeNow Time.now
    )



-- UPDATE


type alias CounterId =
    Int


type Msg
    = Increment CounterId
    | Decrement CounterId
    | Reset CounterId
    | Remove CounterId
    | TimeNow Time.Posix
    | OnTyping String


removeElement : Int -> List a -> List a
removeElement id list =
    list
        |> List.indexedMap (\index counter -> ( index, counter ))
        |> List.filter (\( index, counter ) -> id /= index)
        |> List.map (\( _, counter ) -> counter)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        OnTyping text ->
            if text == "" then
                ( { model | inputFieldContent = 0 }, Cmd.none )

            else
                ( { model | inputFieldContent = Maybe.withDefault model.inputFieldContent <| String.toInt text }, Cmd.none )

        TimeNow time ->
            ( { model | time = Just time }, Cmd.none )

        Reset id ->
            let
                array =
                    Array.fromList model.counters

                newArray =
                    Array.set id 0 array
            in
            ( { model | counters = Array.toList newArray }, Cmd.none )

        Remove id ->
            ( { model | counters = removeElement id model.counters }, Cmd.none )

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
    layout [] <|
        column []
            [ Input.text []
                { label = Input.labelAbove [] <| text "Type something"
                , onChange = OnTyping
                , placeholder = Nothing
                , text =
                    if model.inputFieldContent == 0 then
                        ""

                    else
                        String.fromInt model.inputFieldContent
                }
            , Input.button [] { label = text "Add Counter", onPress = Nothing }
            , row [ spacing 20 ] <|
                List.indexedMap
                    (\id count ->
                        Counter.counterComponent
                            { count = count
                            , msgDec = Decrement id
                            , msgInc = Increment id
                            , msgRemove = Remove id
                            , msgReset = Reset id
                            }
                    )
                    model.counters
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
