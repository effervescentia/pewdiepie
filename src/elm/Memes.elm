module Memes exposing (..)

import Css exposing (property, px, transform, translateX)
import Images
import Meme exposing (Meme)


memes : List Meme
memes =
    [ Meme "bike cuck"
        ""
        Images.bikeCuck
        [ transform (translateX (px 30))
        , property "filter" "saturate(130%)"
        ]
    , Meme "bike cuck 2"
        ""
        Images.bikeCuck
        [ transform (translateX (px 30))
        , property "filter" "saturate(130%)"
        ]
    , Meme "bike cuck 3 "
        ""
        Images.bikeCuck
        [ transform (translateX (px 30))
        , property "filter" "saturate(130%)"
        ]
    ]
