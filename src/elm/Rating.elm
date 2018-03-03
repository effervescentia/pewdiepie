module Rating exposing (..)

import Css exposing (Style, absolute, alignItems, bottom, center, color, column, displayFlex, flexDirection, int, justifyContent, left, margin, margin2, marginBottom, marginLeft, num, padding, pc, pct, position, property, px, relative, textAlign, top, transform, translate, translate2, translateX, translateY, width, zIndex, zero)
import Html.Styled exposing (Html, div, fromUnstyled, h1, img, text)
import Html.Styled.Attributes exposing (css, src)
import InlineSvg exposing (inline)
import Styles exposing (animatedLoop)


-- CONSTANTS


{ icon } =
    inline
        { pewds = "../../assets/pewds.svg"
        , speechBubble = "../../assets/speech_bubble2.svg"
        }



-- STYLE


type alias Styles =
    { root : List Style
    , container : List Style
    , speechBubble : List Style
    , pewds : List Style
    , rating : List Style
    }


styles : Styles
styles =
    { root =
        [ position absolute
        , bottom (px 64)
        , left (pct 50)
        , transform <| translateX (pct -50)
        , property "filter" "drop-shadow(-8px 5px 16px rgba(0,0,0,0.7))"
        ]
    , container =
        [ position relative
        , displayFlex
        ]
    , speechBubble =
        [ width (px 200)
        ]
    , pewds =
        [ width (px 60)
        , marginLeft (px 20)
        , property "animation-name" "twist"
        , animatedLoop 8
        ]
    , rating =
        [ position absolute
        , width (px 175)
        ]
    }



-- VIEW


view : String -> Html msg
view rating =
    div [ css styles.root ]
        [ div [ css styles.container ]
            [ div [ css styles.speechBubble ]
                [ fromUnstyled (icon .speechBubble [])
                ]
            , div [ css styles.pewds ]
                [ fromUnstyled (icon .pewds [])
                ]
            , div [ css styles.rating ]
                [ h1 [] [ text rating ]
                ]
            ]
        ]
