module Counter exposing (counterComponent)

-- 040_TYPE_SIGNATURE

import Array
import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Html.Events exposing (onClick)
import Task
import Time


attrs : List (Attribute msg)
attrs =
    [ Border.width 1, padding 5, width <| px 50 ]


counterComponent : msg -> msg -> Int -> Element msg
counterComponent msgInc msgDec count =
    column
        [ spacing 20
        ]
        [ Input.button attrs
            { label = el [ centerX ] <| text "+1"
            , onPress = Just msgInc
            }
        , el [ centerX ] <| text (String.fromInt count)
        , Input.button attrs
            { label = el [ centerX ] <| text "-1"
            , onPress = Just msgDec
            }
        ]
