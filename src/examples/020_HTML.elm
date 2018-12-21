module Main exposing (main)

-- 020_HTML

import Html exposing (..)
import Html.Attributes exposing (..)


main =
    div [ id "counter" ]
        [ button [ id "counter" ] [ text "+1" ]
        , div [] [ text <| String.fromInt 0 ]
        , button [] [ text "+1" ]
        ]



{-
   <div id="counter">
       <button>+1</button>
       <div>0</div>
       <button>-1</button>
   </div>
-}
