module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html
import Http



-- unirest.get("https://rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com/services/api/Product/Search/20170426?keyword=water")
-- .header("X-RapidAPI-Host", "rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com")
-- .header("X-RapidAPI-Key", "be54c6940emsh8244442e99ee3f3p1d8758jsnc5dfa77ab60f")
-- .end(function (result) {
--   console.log(result.status, result.headers, result.body);
-- });
-- MODEL


type alias Model =
    { inputFieldContent : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { inputFieldContent = "" }, Cmd.none )


type Msg
    = OnTyping String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        OnTyping text ->
            ( { model | inputFieldContent = text }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    layout [ padding 30 ] <|
        column [ width fill ]
            [ Input.text []
                { label = Input.labelHidden "Search products"
                , onChange = OnTyping
                , placeholder = Just <| Input.placeholder [] <| text "Search products"
                , text = model.inputFieldContent
                }
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
