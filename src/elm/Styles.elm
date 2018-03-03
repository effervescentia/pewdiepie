module Styles exposing (..)

import Css exposing (Style, property)


animatedLoop : Float -> Style
animatedLoop duration =
    Css.batch
        [ property "animation-duration" <| (toString duration) ++ "s"
        , property "animation-fill-mode" "both"
        , property "animation-timing-function" "linear"
        , property "animation-iteration-count" "infinite"
        ]
