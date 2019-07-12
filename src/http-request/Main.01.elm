module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Http
import Json.Decode
import Json.Decode.Pipeline
import Process
import Task


getProducts : Model -> Cmd Msg
getProducts model =
    Http.request
        { url = "products.json"

        --, url = "https://rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com/services/api/Product/Search/20170426?keyword=" ++ model.inputFieldContent
        , expect = Http.expectJson GotProducts decodeApiResponse
        , method = "GET"
        , headers =
            [ Http.header "X-RapidAPI-Host" "rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com"
            , Http.header "X-RapidAPI-Key" "be54c6940emsh8244442e99ee3f3p1d8758jsnc5dfa77ab60f"
            ]
        , timeout = Nothing
        , tracker = Nothing
        , body = Http.emptyBody
        }


type alias ApiResponse =
    { count : Int
    , page : Int
    , first : Int
    , last : Int
    , hits : Int
    , pageCount : Int
    , products : List Product
    }


type alias Product =
    { product : Product2
    }


type alias Product2 =
    { productName : String
    , smallImageUrl : String
    }


decodeApiResponse : Json.Decode.Decoder ApiResponse
decodeApiResponse =
    Json.Decode.succeed ApiResponse
        |> Json.Decode.Pipeline.required "count" Json.Decode.int
        |> Json.Decode.Pipeline.required "page" Json.Decode.int
        |> Json.Decode.Pipeline.required "first" Json.Decode.int
        |> Json.Decode.Pipeline.required "last" Json.Decode.int
        |> Json.Decode.Pipeline.required "hits" Json.Decode.int
        |> Json.Decode.Pipeline.required "pageCount" Json.Decode.int
        |> Json.Decode.Pipeline.required "Products" (Json.Decode.list decodeProduct)


decodeProduct : Json.Decode.Decoder Product
decodeProduct =
    Json.Decode.succeed Product
        |> Json.Decode.Pipeline.required "Product" decodeProduct2


decodeProduct2 : Json.Decode.Decoder Product2
decodeProduct2 =
    Json.Decode.succeed Product2
        |> Json.Decode.Pipeline.required "productName" Json.Decode.string
        |> Json.Decode.Pipeline.required "smallImageUrl" Json.Decode.string



-- MODEL


type alias Model =
    { inputFieldContent : String
    , apiResponse : Maybe ApiResponse
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { inputFieldContent = "bicycle"
            , apiResponse = Nothing
            }
    in
    ( model
    , getProducts model
    )



-- UPDATE


type Msg
    = OnTyping String
    | GotProducts (Result Http.Error ApiResponse)
    | TimePassed String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg |> Debug.log "msg" of
        GotProducts apiResult ->
            case apiResult of
                Ok apiResponse ->
                    ( { model | apiResponse = Just apiResponse }, Cmd.none )

                Err err ->
                    ( model, Cmd.none )

        OnTyping text ->
            ( { model | inputFieldContent = text }
            , Process.sleep 500
                |> Task.perform (\_ -> TimePassed text)
            )

        TimePassed oldText ->
            ( model
            , if oldText == model.inputFieldContent then
                getProducts model

              else
                Cmd.none
            )


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
            , case model.apiResponse of
                Just apiResponse ->
                    column [ padding 40, spacing 30, Background.color <| rgb255 200 200 200 ] <|
                        List.map
                            (\product ->
                                row [ padding 20, Border.rounded 10, width fill, Background.color <| rgb255 255 255 255 ]
                                    [ paragraph [ alignTop ] [ text product.product.productName ]
                                    , image []
                                        { description = product.product.productName
                                        , src = product.product.smallImageUrl
                                        }
                                    ]
                            )
                            apiResponse.products

                Nothing ->
                    el [ padding 300 ] <| text "No products"
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
