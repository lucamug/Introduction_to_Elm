module Counter exposing (Something, counterComponent)

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
    [ Border.width 1
    , padding 5
    , width <| px 100
    ]



--counterComponent : msg -> msg -> msg -> msg -> Int -> Element msg


type alias Something msg =
    { count : Int
    , msgDec : msg
    , msgInc : msg
    , msgRemove : msg
    , msgReset : msg
    }


counterComponent : Something msg -> Element msg
counterComponent { msgInc, msgDec, msgReset, msgRemove, count } =
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
        , Input.button attrs
            { label = el [ centerX ] <| text "Reset"
            , onPress = Just msgReset
            }
        , Input.button attrs
            { label = el [ centerX ] <| text "Remove"
            , onPress = Just msgRemove
            }
        ]
