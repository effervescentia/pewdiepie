module Slider exposing (..)

import Css exposing (Style, center, color, displayFlex, flexBasis, hidden, justifyContent, listStyle, margin, none, overflowX, padding, pct, property, transform, translateX, width, zero)
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
        [ overflowX hidden
        , width (pct 100)
        ]
    , button =
        [ color white
        ]
    , list =
        [ displayFlex
        , width (pct 200)
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
                button
                    [ onClick (activateIndex <| activeIndex - 1)
                    , css styles.button
                    ]
                    [ text "Back" ]
            else
                text ""

        nextButton =
            if activeIndex < List.length (options) - 1 then
                button
                    [ onClick (activateIndex <| activeIndex + 1)
                    , css styles.button
                    ]
                    [ text "Next" ]
            else
                text ""

        offset =
            -100
                / (toFloat <|
                    activeIndex
                        * (List.length options)
                  )

        wrapItem =
            viewItem activeIndex
    in
        div [ css styles.root ]
            [ ul
                [ css styles.list
                , css [ transform <| translateX (pct offset) ]
                ]
              <|
                List.indexedMap wrapItem options
            , backButton
            , nextButton
            ]


viewItem : Int -> Int -> Html msg -> Html msg
viewItem activeIndex index innerEl =
    li [ css styles.listItem ] [ innerEl ]
