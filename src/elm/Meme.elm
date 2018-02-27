module Meme exposing (..)

import Css exposing (Style, absolute, alignItems, bottom, center, color, column, displayFlex, flexDirection, hidden, inherit, initial, int, justifyContent, margin, margin2, marginBottom, marginLeft, num, padding, position, property, px, relative, scale, textAlign, top, transform, translate, translate2, translateX, translateY, visibility, width, zIndex, zero)
import Css.Colors exposing (white)
import Html.Styled exposing (Html, div, fromUnstyled, h1, img, text)
import Html.Styled.Attributes exposing (css, src)
import Images exposing (Asset)
import Rating
import Styles exposing (animatedLoop)
import Svg.Styled exposing (ellipse, svg)
import Svg.Styled.Attributes exposing (cx, cy, rx, ry)


-- MODEL


type AnimationState
    = None
    | ShowRating
    | ShowReview Int
    | Finished


type alias Meme =
    { name : String
    , rating : String
    , image : Asset
    , reviews : List String
    , styles : List Style
    }


type alias Config msg =
    { updateAnimation : AnimationState -> msg
    }


type alias Context =
    { animationState : AnimationState }


init : Context
init =
    { animationState = None }



-- UPDATE


update : AnimationState -> Context
update animationState =
    { animationState = animationState }



-- STYLE


type alias Styles =
    { root : List Style
    , imageContainer : List Style
    , image : List Style
    , shadow : List Style
    , title : List Style
    , ratingContainer : List Style
    }


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
        , animatedLoop 5
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
    }



-- VIEW


view : Config msg -> Context -> Meme -> Html msg
view config context meme =
    let
        visibleStyle =
            case context.animationState of
                None ->
                    [ visibility hidden, transform <| scale 0 ]

                _ ->
                    [ transform <| scale 1 ]

        nextAnimation =
            config.updateAnimation
                (case context.animationState of
                    ShowRating ->
                        if List.length meme.reviews > 0 then
                            ShowReview 0
                        else
                            Finished

                    ShowReview index ->
                        if index < (List.length meme.reviews - 1) then
                            ShowReview <| index + 1
                        else
                            Finished

                    _ ->
                        Finished
                )
    in
        div [ css styles.root ]
            [ div [ css styles.imageContainer ]
                [ div [ css styles.image ]
                    [ img
                        [ src <| Images.use meme.image
                        , css meme.styles
                        ]
                        []
                    ]
                ]
            , div [ css styles.shadow ]
                [ svg []
                    [ ellipse [ cx "150", cy "60", rx "120", ry "25" ] []
                    ]
                ]
            , h1 [ css styles.title ] [ text <| meme.name ++ " meme" ]
            , div
                [ css visibleStyle
                , css styles.ratingContainer
                ]
                [ Rating.view meme.rating ]
            ]
