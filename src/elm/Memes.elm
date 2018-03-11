module Memes exposing (..)

import Css exposing (property, px, transform, translateX, width)
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
        Images.loss
        [ "universal"
        , "adaptable"
        , "a beautiful meme"
        ]
        [ width (px 300)
        ]
    , Meme "petting dog"
        "5.5 / 10"
        Images.pettingDog
        [ "it has many layers"
        , "it transcends humans"
        , "compatible"
        ]
        [ transform (translateX (px -40))
        , width (px 500)
        ]
    , Meme "monkey haircut"
        "5.2 / 10"
        Images.bikeCuck
        [ "it just never stops"
        , "better than petting dog meme"
        , "melancholic depression undertone"
        ]
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    , Meme "dahlia"
        "2 and a half"
        Images.bikeCuck
        [ "truly mindbending material here" ]
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    ]
