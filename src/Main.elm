module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html
import Http
import Json.Decode
import Json.Decode.Pipeline
import Process
import Task



-- unirest.get("https://rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com/services/api/Product/Search/20170426?keyword=water")
-- .header("X-RapidAPI-Host", "rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com")
-- .header("X-RapidAPI-Key", "be54c6940emsh8244442e99ee3f3p1d8758jsnc5dfa77ab60f")
-- .end(function (result) {
--   console.log(result.status, result.headers, result.body);
-- });
-- MODEL


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


getProducts : Model -> Cmd Msg
getProducts model =
    Http.request
        { url = "https://rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com/services/api/Product/Search/20170426?keyword=" ++ model.inputFieldContent
        , expect = Http.expectJson GotProducts decodeApiResponse
        , headers =
            [ Http.header "X-RapidAPI-Host" "rakuten_webservice-rakuten-marketplace-product-search-v1.p.rapidapi.com"
            , Http.header "X-RapidAPI-Key" "be54c6940emsh8244442e99ee3f3p1d8758jsnc5dfa77ab60f"
            ]
        , method = "GET"
        , body = Http.emptyBody
        , timeout = Nothing
        , tracker = Nothing
        }


type alias Model =
    { inputFieldContent : String
    , apiState : ApiState
    }


type ApiState
    = NotRequested
    | NotEnoughCharacters
    | Fetching
    | Succes ApiResponse
    | Error Http.Error


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { inputFieldContent = "water"
            , apiState = NotRequested
            }
    in
    ( model
      --, getProducts model
    , Cmd.none
    )


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
                    ( { model | apiState = Succes apiResponse }, Cmd.none )

                Err error ->
                    ( { model | apiState = Error error }, Cmd.none )

        OnTyping text ->
            let
                newModel =
                    { model | inputFieldContent = text }
            in
            ( newModel
            , Process.sleep 500 |> Task.perform (\_ -> TimePassed text)
            )

        TimePassed oldText ->
            if oldText == model.inputFieldContent then
                if String.length oldText < 3 then
                    ( { model | apiState = NotEnoughCharacters }, Cmd.none )

                else
                    ( { model | apiState = Fetching }, getProducts model )

            else
                ( model, Cmd.none )


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
            , case model.apiState of
                Succes response ->
                    column [] <|
                        List.map
                            (\product ->
                                row [ width fill ]
                                    [ paragraph [] [ text product.product.productName ]
                                    , image []
                                        { description = product.product.productName
                                        , src = product.product.smallImageUrl
                                        }
                                    ]
                            )
                            response.products

                Error _ ->
                    text "Error"

                NotRequested ->
                    text "Not requested"

                Fetching ->
                    text "Fetching"

                NotEnoughCharacters ->
                    text "NotEnoughCharacters"
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
