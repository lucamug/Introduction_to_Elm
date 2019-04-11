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



-- type Maybe a = Just a | Nothing


type alias Item =
    { name : String
    , price : Maybe Int
    }


dataFromDB : List Item
dataFromDB =
    [ { name = "one", price = Nothing }
    , { name = "two", price = Just 0 }
    , { name = "three", price = Just 545354 }
    , { name = "two", price = Just 0 }
    ]



-- MODEL


type alias Flags =
    ()


type alias Model =
    { count : Int
    , width : Int
    , dataFromDB : Maybe (List Item)
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { count = 10
      , width = 0
      , dataFromDB = Just dataFromDB
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | DeleteItem String
    | OnResize Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        OnResize x _ ->
            ( { model | width = x }, Cmd.none )

        DeleteItem itemName ->
            let
                items =
                    case model.dataFromDB of
                        Nothing ->
                            []

                        Just items_ ->
                            items_

                newItems =
                    -- TODO
                    List.filter (\item -> item.name /= itemName) items
            in
            ( { model | dataFromDB = Just newItems }, Cmd.none )



-- VIEW


blue : Color
blue =
    rgb 0.1 0.6 1


red : Color
red =
    rgb 0.8 0.2 0.2


buttonColor : Color
buttonColor =
    red


buttonAttributes : List (Attr () msg)
buttonAttributes =
    [ Background.color <| buttonColor
    , Border.rounded 5
    , padding 10
    , width <| px 100
    , Font.center
    ]


view : Model -> Html Msg
view model =
    layout [ width fill, height fill, padding 10 ] <|
        column [ spacing 20 ]
            [ text "List of Items"
            , column [ spacing 10 ] <|
                case model.dataFromDB of
                    Nothing ->
                        []

                    Just listOfItem ->
                        -- map : (a -> b) -> List a -> List b
                        --
                        -- a = Item
                        --
                        -- (a -> b) = (Item -> Element msg)
                        List.indexedMap
                            (\index item ->
                                row [ spacing 10 ]
                                    [ text <| String.fromInt (index + 1)
                                    , Input.button buttonAttributes
                                        { onPress = Just (DeleteItem item.name), label = text "Delete" }
                                    , text item.name
                                    , text <|
                                        case item.price of
                                            Nothing ->
                                                "Price is missing"

                                            Just price ->
                                                String.fromInt price
                                    ]
                            )
                            listOfItem
            , (if model.width < 500 then
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
            ]



-- SUBSCRIPTIONS


subscriptions : a -> Sub Msg
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
