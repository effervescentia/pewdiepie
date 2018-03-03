module Meme exposing (..)

import Css exposing (Style, absolute, alignItems, bottom, center, color, column, displayFlex, flexDirection, int, justifyContent, margin, margin2, marginBottom, marginLeft, num, padding, position, property, px, relative, textAlign, top, transform, translate, translate2, translateX, translateY, width, zIndex, zero)
import Css.Colors exposing (white)
import Html.Styled exposing (Html, div, fromUnstyled, h1, img, text)
import Html.Styled.Attributes exposing (css, src)
import Images exposing (Asset)
import InlineSvg exposing (inline)
import Svg.Styled exposing (ellipse, svg)
import Svg.Styled.Attributes exposing (cx, cy, rx, ry)


-- CONSTANTS


{ icon } =
    inline
        { pewds = "../../assets/pewds.svg"
        , speechBubble = "../../assets/speech_bubble2.svg"
        }



-- MODEL


type alias Meme =
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
    , shadow : List Style
    , title : List Style
    , rating : List Style
    , speechBubble : List Style
    , pewds : List Style
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
        , justifyContent center
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
        , property "filter" "drop-shadow(-20px 15px 32px rgba(0,0,0,0.7))"
        ]
    , shadow =
        [ property "filter" "blur(24px) opacity(.6)"
        , property "animation-name" "swell"
        , zIndex (int -1)
        , animatedLoop
        ]
    , title =
        [ position absolute
        , top zero
        , margin2 (px 16) zero
        , color white
        ]
    , rating =
        [ position absolute
        , displayFlex
        , bottom zero
        , margin2 (px 64) zero
        , property "filter" "drop-shadow(-8px 5px 16px rgba(0,0,0,0.7))"
        , transform <| translateX (px 50)
        ]
    , speechBubble =
        [ width (px 200)
        ]
    , pewds =
        [ width (px 60)
        , marginLeft (px 20)
        , property "animation-name" "twist"
        , animatedLoop
        , property "animation-duration" "8s"
        ]
    }



-- VIEW


view : Meme -> Html msg
view model =
    div [ css styles.root ]
        [ div [ css styles.imageContainer ]
            [ div [ css styles.image ]
                [ img
                    [ src <| Images.use model.image
                    , css model.styles
                    ]
                    []
                ]
            ]
        , div [ css styles.shadow ]
            [ svg []
                [ ellipse [ cx "150", cy "60", rx "120", ry "25" ] []
                ]
            ]
        , h1 [ css styles.title ] [ text model.name ]
        , div [ css styles.rating ]
            [ div [ css styles.speechBubble ]
                [ fromUnstyled (icon .speechBubble [])
                ]
            , div [ css styles.pewds ]
                [ fromUnstyled (icon .pewds [])
                ]
            ]
        ]
