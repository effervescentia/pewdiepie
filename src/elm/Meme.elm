module Meme exposing (..)

import Css exposing (Style, absolute, alignItems, bolder, bottom, center, color, column, deg, displayFlex, flexDirection, fontSize, fontWeight, height, hidden, inherit, initial, int, justifyContent, left, margin, margin2, marginBottom, marginLeft, num, padding, pct, position, property, px, relative, rem, right, rotate, scale, textAlign, top, transform, translate, translate2, translateX, translateY, visibility, width, zIndex, zero)
import Css.Colors exposing (white)
import Delay
import Html.Styled exposing (Html, div, fromUnstyled, h1, img, text)
import Html.Styled.Attributes exposing (css, src)
import Images exposing (Asset)
import InlineSvg exposing (inline)
import List.Extra
import Rating
import String exposing (toUpper)
import Styles exposing (animatedLoop)
import Svg.Attributes
import Svg.Styled exposing (ellipse, svg, text_)
import Svg.Styled.Attributes exposing (alignmentBaseline, cx, cy, rx, ry, stroke, strokeWidth, textAnchor, x, y)
import Time exposing (millisecond)


{ icon } =
    inline
        { spikeBubble = "../../assets/spike_bubble.svg"
        }



-- MODEL


type AnimationStep
    = None
    | ShowRating
    | ShowReview Int
    | Done


type alias Meme =
    { name : String
    , rating : String
    , image : Asset
    , reviews : List String
    , styles : List Style
    }


type alias Config msg =
    { updateAnimation : Msg -> msg
    , animationsEnabled : Bool
    }


type alias Context =
    { animationStep : AnimationStep
    }


init : Float -> ( Context, Cmd Msg )
init time =
    { animationStep = None
    }
        ! [ Delay.after time millisecond (AnimateStep ShowRating) ]


initFinal : Context
initFinal =
    { animationStep = Done
    }



-- UPDATE


type Msg
    = AnimateStep AnimationStep


update : Msg -> Context -> Meme -> ( Context, Cmd Msg )
update msg context meme =
    case msg of
        AnimateStep step ->
            let
                delay =
                    Delay.after 1000 millisecond

                nextCmd =
                    case step of
                        ShowRating ->
                            if List.length meme.reviews > 0 then
                                delay (AnimateStep <| ShowReview 0)
                            else
                                Cmd.none

                        ShowReview index ->
                            let
                                nextIndex =
                                    index + 1
                            in
                                if List.length meme.reviews - 1 == nextIndex then
                                    delay (AnimateStep Done)
                                else if List.length meme.reviews > nextIndex then
                                    delay (AnimateStep <| ShowReview nextIndex)
                                else
                                    Cmd.none

                        _ ->
                            Cmd.none
            in
                ( { context | animationStep = step }, nextCmd )



-- STYLE


type alias Styles =
    { root : List Style
    , imageContainer : List Style
    , image : List Style
    , shadow : List Style
    , title : List Style
    , ratingContainer : List Style
    , reviewContainer : List Style
    , review : List Style
    , reviewInner : List Style
    , reviewText : List Style
    }


styles : Styles
styles =
    { root =
        [ displayFlex
        , position relative
        , width (pct 100)
        , flexDirection column
        , alignItems center
        , justifyContent center
        , textAlign center
        ]
    , imageContainer =
        [ marginBottom (px 24)
        , property "animation-name" "bounce"
        , animatedLoop 5
        ]
    , image =
        [ position relative
        , transform (translateY (px 25))
        , property "filter" "drop-shadow(-20px 15px 32px rgba(0,0,0,0.7))"
        ]
    , shadow =
        [ property "animation-name" "swell"
        , zIndex (int -1)
        , animatedLoop 5
        ]
    , title =
        [ position absolute
        , top zero
        , margin2 (px 16) zero
        , color white
        ]
    , ratingContainer =
        [ property "transition" "transform .5s ease"
        ]
    , reviewContainer =
        [ position absolute
        , width (px 250)
        ]
    , review =
        [ property "transition" "transform .1s ease-out"
        ]
    , reviewInner =
        [ position relative
        , property "animation-name" "twist-small"
        , animatedLoop 12
        ]
    , reviewText =
        [ position absolute
        , left (pct 50)
        , top (pct 50)
        , transform <| translate2 (pct -50) (pct -50)
        , color white
        , fontSize (Css.rem 2.4)
        , fontWeight bolder
        ]
    }


reviewStyles : List (List Style)
reviewStyles =
    [ [ top (px 24)
      , left (px 24)
      , transform <| rotate (deg -25)
      ]
    , [ top (px 24)
      , right (px 24)
      , transform <| rotate (deg 25)
      ]
    , [ bottom (px 80)
      , left (px 24)
      , transform <| rotate (deg 25)
      ]
    , [ bottom (px 80)
      , right (px 24)
      , transform <| rotate (deg -25)
      ]
    ]



-- VIEW


view : Config msg -> Context -> Meme -> Html msg
view { updateAnimation } { animationStep } meme =
    let
        ratingStyles =
            case animationStep of
                None ->
                    [ visibility hidden, transform <| scale 0 ]

                _ ->
                    [ transform <| scale 1 ]
    in
        div [ css styles.root ]
            [ div
                [ css styles.imageContainer ]
                [ div
                    [ css styles.image ]
                    [ img
                        [ src <| Images.use meme.image
                        , css meme.styles
                        ]
                        []
                    ]
                ]
            , div
                [ css styles.shadow ]
                [ svg []
                    [ ellipse [ cx "150", cy "60", rx "120", ry "25" ] []
                    ]
                ]
            , h1 [ css styles.title ] [ text <| meme.name ++ " meme" ]
            , div
                [ css ratingStyles
                , css styles.ratingContainer
                ]
                [ Rating.view meme.rating ]
            , div [] <|
                List.indexedMap
                    (viewConditionalReview animationStep)
                <|
                    List.take 4
                        meme.reviews
            ]


viewConditionalReview : AnimationStep -> Int -> String -> Html msg
viewConditionalReview step index review =
    let
        innerReview =
            viewReview review <|
                Maybe.withDefault [] <|
                    List.Extra.getAt index reviewStyles

        hiddenStyles =
            [ visibility hidden, transform <| scale 0 ]

        visibleStyles =
            [ transform <| scale 1 ]
    in
        case step of
            None ->
                innerReview
                    hiddenStyles

            ShowRating ->
                innerReview
                    hiddenStyles

            ShowReview activeIndex ->
                innerReview
                    (if activeIndex >= index then
                        visibleStyles
                     else
                        [ visibility hidden, transform <| scale 0 ]
                    )

            Done ->
                innerReview visibleStyles


viewReview : String -> List Style -> List Style -> Html msg
viewReview review containerStyles innerStyles =
    div
        [ css styles.reviewContainer
        , css containerStyles
        ]
        [ div
            [ css styles.review
            , css innerStyles
            ]
            [ div [ css styles.reviewInner ]
                [ fromUnstyled (icon .spikeBubble [ Svg.Attributes.color "#ffe404" ])

                -- , div [ css styles.reviewText ] [ text review ]
                , div [ css styles.reviewText ]
                    [ Svg.Styled.svg []
                        [ text_
                            [ textAnchor "middle"
                            , alignmentBaseline "central"
                            , x "50%"
                            , y "50%"
                            , stroke "black"
                            , strokeWidth "2px"
                            ]
                            [ Svg.Styled.text <| toUpper review ]
                        ]
                    ]
                ]
            ]
        ]
