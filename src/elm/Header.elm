module Header exposing (..)

import Css exposing (Style, absolute, center, color, displayFlex, flex, hidden, left, margin, none, num, overflowX, padding, padding2, pct, position, property, px, relative, right, textAlign, textDecoration, top, transform, translateX, translateY, vw, width, zero)
import Css.Colors exposing (white)
import Html.Styled exposing (Html, a, header, li, nav, text, ul)
import Html.Styled.Attributes exposing (css, href, style)
import Html.Styled.Events as Events exposing (onWithOptions)
import Json.Decode as Decode
import List.Extra


-- CONSTANTS


type alias Route routeView =
    { view : routeView
    , url : String
    , label : String
    , styles : List Style
    }


type LinkVariant
    = None
    | Back
    | Next


clickOptions : Events.Options
clickOptions =
    { preventDefault = True
    , stopPropagation = False
    }



-- STYLE


type alias Styles =
    { root : List Style
    , navbar : List Style
    , list : List Style
    , listItem : List Style
    , link : List Style
    , navLink : List Style
    , backLink : List Style
    , nextLink : List Style
    }


styles : Styles
styles =
    { root =
        [ position relative
        , overflowX hidden
        ]
    , navbar = [ width (vw 200) ]
    , list =
        [ displayFlex
        , margin zero
        , padding zero
        , textAlign center
        ]
    , listItem =
        [ flex (num 1)
        , padding2 (px 16) (px 8)
        ]
    , link =
        [ color white
        , textDecoration none
        ]
    , navLink =
        [ position absolute
        , top (pct 50)
        , transform <| translateY (pct -50)
        ]
    , backLink = [ left (px 16) ]
    , nextLink = [ right (px 16) ]
    }



-- VIEW


view : List (Route routeView) -> routeView -> (routeView -> msg) -> Html msg
view links activeView changeView =
    let
        activeIndex =
            case List.Extra.findIndex (\{ view } -> view == activeView) links of
                Just index ->
                    index

                Nothing ->
                    -1

        backLink =
            conditionalLink (List.take activeIndex links) activeIndex Back changeView

        nextLink =
            conditionalLink (List.drop (activeIndex + 1) links) activeIndex Next changeView
    in
        header [ css styles.root ]
            [ nav [ css [ width (vw <| toFloat <| List.length links * 100) ] ]
                [ ul
                    [ css styles.list
                    , css
                        [ transform <| translateX (pct <| toFloat <| -100 // List.length links * activeIndex)
                        , property "transition" "transform .8s ease-in-out"
                        ]
                    ]
                  <|
                    List.map (toNavigationOption changeView) links
                , backLink
                , nextLink
                ]
            ]


conditionalLink : List (Route view) -> Int -> LinkVariant -> (view -> msg) -> Html msg
conditionalLink links activeIndex variant changeView =
    case List.head links of
        Just route ->
            viewLink route changeView variant

        Nothing ->
            text ""


viewLink : Route routeView -> (routeView -> msg) -> LinkVariant -> Html msg
viewLink { url, label, view } changeView variant =
    let
        ( content, variantStyles ) =
            case variant of
                None ->
                    ( label, [] )

                Next ->
                    ( ">", [ css styles.navLink, css styles.nextLink ] )

                Back ->
                    ( "<", [ css styles.navLink, css styles.backLink ] )
    in
        a
            ([ href <| "/" ++ url
             , onWithOptions "click" clickOptions <| Decode.succeed <| changeView view
             , css styles.link
             ]
                ++ variantStyles
            )
            [ text content ]



-- FUNCTIONS


toNavigationOption : (view -> msg) -> Route view -> Html msg
toNavigationOption changeView route =
    li [ css styles.listItem, css route.styles ] [ viewLink route changeView None ]
