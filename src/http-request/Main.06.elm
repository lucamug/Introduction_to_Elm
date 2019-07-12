module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Http



-- unirest.get("https://rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com/services/api/Product/Search/20170426?keyword=water")
-- .header("X-RapidAPI-Host", "rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com")
-- .header("X-RapidAPI-Key", "be54c6940emsh8244442e99ee3f3p1d8758jsnc5dfa77ab60f")
-- .end(function (result) {
--   console.log(result.status, result.headers, result.body);
-- });
-- MODEL


getProducts : Cmd Msg
getProducts =
    Http.get
        { url = "https://rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com/services/api/Product/Search/20170426?keyword=water"
        , expect = Http.expectString GotProducts
        }


type alias Model =
    { inputFieldContent : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { inputFieldContent = "bicycle" }, getProducts )



-- UPDATE


type Msg
    = OnTyping String
    | GotProducts (Result Http.Error String)


removeElement : Int -> List a -> List a
removeElement id list =
    list
        |> List.indexedMap (\index counter -> ( index, counter ))
        |> List.filter (\( index, counter ) -> id /= index)
        |> List.map (\( _, counter ) -> counter)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotProducts _ ->
            ( model, Cmd.none )

        OnTyping text ->
            ( { model | inputFieldContent = text }, Cmd.none )


view : Model -> Html Msg
view model =
    layout [ padding 30 ] <|
        column [ width fill ]
            [ Input.text [ centerX, width <| px 400 ]
                { label = Input.labelHidden "Search products"
                , onChange = OnTyping
                , placeholder = Just <| Input.placeholder [] <| text "Search products"
                , text = model.inputFieldContent
                }
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
