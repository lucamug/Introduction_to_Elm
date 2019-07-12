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
    { componentModel : SuperCounter.Model
    , componentModel2 : SuperCounter.Model
    }



-- add a b  = a + b
-- add = \a b -> a + b


init : () -> ( Model, Cmd Msg )
init flags =
    let
        ( componentModel, componentCmd ) =
            SuperCounter.init flags
    in
    ( { componentModel = componentModel
      , componentModel2 = componentModel
      }
      -- Task.perform : (Time.Posix -> msg) -> Task Never Time.Posix -> Cmd msg
      -- Time.now : Task x Time.Posix
    , Cmd.batch
        [ Cmd.map MessagesForSuperCounter componentCmd
        ]
    )



-- UPDATE


type Msg
    = MessagesForSuperCounter SuperCounter.Msg
    | MessagesForSuperCounter2 SuperCounter.Msg
    | DoNothing


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg |> Debug.log "msg" of
        DoNothing ->
            ( { model
                | componentModel = Tuple.first <| SuperCounter.init ()
                , componentModel2 = Tuple.first <| SuperCounter.init ()
              }
            , Cmd.none
            )

        MessagesForSuperCounter msgForSuperCounter ->
            let
                ( superCounterModel, superCounterCmd ) =
                    SuperCounter.update
                        msgForSuperCounter
                        model.componentModel
            in
            ( { model | componentModel = superCounterModel }, superCounterCmd )

        MessagesForSuperCounter2 msgForSuperCounter ->
            let
                ( superCounterModel, superCounterCmd ) =
                    SuperCounter.update
                        msgForSuperCounter
                        model.componentModel2
            in
            ( { model | componentModel2 = superCounterModel }, superCounterCmd )


view : Model -> Html Msg
view model =
    Html.div []
        [ layout [] <|
            Input.button []
                { label = text "button"
                , onPress = Just DoNothing
                }
        , Html.map MessagesForSuperCounter (SuperCounter.view model.componentModel)
        , Html.map MessagesForSuperCounter2 (SuperCounter.view model.componentModel2)
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
