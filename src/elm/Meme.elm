module Meme exposing (..)

import Css exposing (Style, absolute, alignItems, bottom, center, color, column, displayFlex, flexDirection, int, margin, margin2, marginBottom, num, padding, position, property, px, relative, textAlign, top, transform, translate, translate2, translateY, zIndex, zero)
import Css.Colors exposing (white)
import Html.Styled exposing (Html, div, h1, img, text)
import Html.Styled.Attributes exposing (css, src)
import Images exposing (Asset)
import Svg.Styled exposing (ellipse, svg)
import Svg.Styled.Attributes exposing (cx, cy, rx, ry)


-- MODEL


type alias Model =
    { name : String
    , rating : String
    , image : Asset
    , styles : List Style
    }



-- STYLE


type alias Styles =
    { root : List Style
    , imageContainer : List Style
    , image : List Style
    , imageShadow : List Style
    , shadow : List Style
    , title : List Style
    }


animatedLoop : Style
animatedLoop =
    Css.batch
        [ property "animation-duration" "5s"
        , property "animation-fill-mode" "both"
        , property "animation-timing-function" "linear"
        , property "animation-iteration-count" "infinite"
        ]


styles : Styles
styles =
    { root =
        [ displayFlex
        , position relative
        , flexDirection column
        , alignItems center
        , textAlign center
        ]
    , imageContainer =
        [ marginBottom (px 24)
        , property "animation-name" "bounce"
        , animatedLoop
        ]
    , image =
        [ position relative
        , transform (translateY (px 25))
        ]
    , imageShadow =
        [ position absolute
        , top zero
        , transform (translate2 (px -20) (px 15))
        , zIndex (int -1)
        , property "filter" "contrast(0%) brightness(0%) blur(20px) opacity(.4)"
        ]
    , shadow =
        [ property "filter" "blur(24px) opacity(.6)"
        , property "animation-name" "swell"
        , animatedLoop
        ]
    , title =
        [ position absolute
        , bottom zero
        , margin2 (px 64) zero
        , color white
        ]
    }



-- VIEW


view : Model -> Html msg
view model =
    div [ css styles.root ]
        [ div [ css styles.imageContainer ]
            [ div [ css styles.image ]
                [ img
                    [ src <| Images.use model.image
                    , css model.styles
                    ]
                    []
                , div [ css styles.imageShadow ]
                    [ img
                        [ src <| Images.use model.image
                        , css model.styles
                        ]
                        []
                    ]
                ]
            ]
        , div [ css styles.shadow ]
            [ svg []
                [ ellipse [ cx "150", cy "60", rx "120", ry "25" ] []
                ]
            ]
        , h1 [ css styles.title ] [ text model.name ]
        ]
