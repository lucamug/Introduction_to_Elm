module Main exposing (main)

-- 030_TEA

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)



-- MODEL


init =
    { count = 0 }



-- UPDATE (CONTROLLER)


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }



-- VIEW


view model =
    div []
        [ button [ onClick Increment ] [ text "+1" ]
        , div [] [ text (String.fromInt model.count) ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]



-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



{-
   PATTERN MATCHING - Remove one case
-}
