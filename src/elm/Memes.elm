module Memes exposing (..)

import Css exposing (property, px, transform, translateX)
import Images
import Meme exposing (Meme)


memes : List Meme
memes =
    [ Meme "bike cuck"
        "8 / 10"
        Images.bikeCuck
        []
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    , Meme "loss"
        "10 / 10"
        Images.bikeCuck
        []
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    , Meme "petting dog"
        "5.5 / 10"
        Images.bikeCuck
        []
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    , Meme "monkey haircut"
        "5.2 / 10"
        Images.bikeCuck
        []
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    , Meme "dahlia"
        "2.5"
        Images.bikeCuck
        []
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    ]
