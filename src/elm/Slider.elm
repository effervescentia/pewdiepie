module Slider exposing (..)

import Css exposing (Style, absolute, center, color, cursor, displayFlex, flexBasis, height, hidden, justifyContent, left, listStyle, margin, none, num, overflowX, padding, pct, pointer, position, property, relative, right, top, transform, translateX, translateY, width, zero)
import Css.Colors exposing (white)
import Html.Styled exposing (Html, button, div, li, text, ul)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)


-- MODEL


type alias Context =
    { activeIndex : Int
    }


type alias Config msg =
    { activateIndex : Int -> msg
    }


init : Context
init =
    { activeIndex = 0 }



-- STYLE


type alias Styles =
    { root : List Style
    , button : List Style
    , list : List Style
    , listItem : List Style
    }


styles : Styles
styles =
    { root =
        [ position relative
        , height (pct 100)
        , width (pct 100)
        , overflowX hidden
        ]
    , button =
        [ position absolute
        , top (pct 50)
        , transform <| translateY (pct -50)
        , color white
        , cursor pointer
        ]
    , list =
        [ displayFlex
        , height (pct 100)
        , margin zero
        , padding zero
        , listStyle none
        , property "transition" "transform 1s ease"
        ]
    , listItem =
        [ displayFlex
        , flexBasis (pct 50)
        , justifyContent center
        ]
    }



-- VIEW


view : Config msg -> Context -> List (Html msg) -> Html msg
view { activateIndex } { activeIndex } options =
    let
        backButton =
            if activeIndex > 0 then
                viewControl "Back" (activateIndex <| activeIndex - 1) [ left zero ]
            else
                text ""

        nextButton =
            if activeIndex < List.length (options) - 1 then
                viewControl "Next" (activateIndex <| activeIndex + 1) [ right zero ]
            else
                text ""

        offset =
            toFloat activeIndex
                * -100
                / (toFloat <| List.length options)

        wrapItem =
            viewItem activeIndex
    in
        div [ css styles.root ]
            [ ul
                [ css styles.list
                , css
                    [ width (pct <| toFloat <| 100 * List.length options)
                    , transform <| translateX (pct offset)
                    ]
                ]
              <|
                List.indexedMap wrapItem options
            , backButton
            , nextButton
            ]


viewControl : String -> msg -> List Style -> Html msg
viewControl label handleClick subStyles =
    button
        [ onClick handleClick
        , css styles.button
        , css subStyles
        ]
        [ text label ]


viewItem : Int -> Int -> Html msg -> Html msg
viewItem activeIndex index innerEl =
    li [ css styles.listItem ] [ innerEl ]



-- FUNCTIONS


mapAnimationType : msg -> String -> msg
mapAnimationType handleChange animationType =
    let
        someType =
            Debug.log "type" animationType
    in
        handleChange
