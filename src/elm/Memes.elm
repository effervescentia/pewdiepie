module Memes exposing (..)

import Css exposing (property, px, transform, translateX, width)
import Images
import Meme exposing (Meme)


memes : List Meme
memes =
    [ Meme "bike cuck"
        "8 / 10"
        "http://knowyourmeme.com/memes/my-bike-got-stolen-recently"
        ""
        Images.bikeCuck
        []
        [ transform (translateX (px 20))
        , property "filter" "saturate(130%)"
        ]
    , Meme "loss"
        "10 / 10"
        "http://knowyourmeme.com/memes/cadbortion-loss-edits"
        ""
        Images.loss
        [ ( [ "universal" ], 0.9, 56 )
        , ( [ "adaptable" ], 0.9, 56 )
        , ( [ "a beautiful", "meme" ], 0.75, 48 )
        ]
        [ width (px 300)
        ]
    , Meme "petting dog"
        "5.5 / 10"
        "http://knowyourmeme.com/memes/dog-petting-photoshops"
        ""
        Images.pettingDog
        [ ( [ "it has", "many layers" ], 0.75, 42 )
        , ( [ "it transcends", "humans" ], 0.7, 50 )
        , ( [ "compatible" ], 0.8, 58 )
        ]
        [ transform (translateX (px -40))
        , width (px 500)
        ]
    , Meme "monkey haircut"
        "5.2 / 10"
        "http://knowyourmeme.com/memes/monkey-haircut"
        ""
        Images.monkeyHaircut
        [ ( [ "it just", "never stops" ], 0.75, 42 )
        , ( [ "better than", "petting", "dog meme" ], 0.6, 38 )
        , ( [ "melancholic", "depression", "undertone" ], 0.6, 38 )
        ]
        [ width (px 350) ]
    , Meme "dahlia"
        "2 and a half"
        "http://knowyourmeme.com/memes/events/xenoblade-chronicles-2-tsuki-character-design-controversy"
        ""
        Images.dahlia
        [ ( [ "truly mindbending", "material here" ], 0.5, 48 ) ]
        [ width (px 300)
        ]
    ]
