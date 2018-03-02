module Header exposing (..)

import Css exposing (Style, absolute, backgroundColor, center, color, displayFlex, flex, hidden, left, margin, num, overflowX, padding2, pct, position, px, relative, right, textAlign, top, transform, translateX, translateY, vw, width, zero)
import Css.Colors exposing (black, white)
import Html.Styled exposing (Html, a, header, li, nav, text, ul)
import Html.Styled.Attributes exposing (css, href, style)
import Html.Styled.Events as Events exposing (onWithOptions)
import Json.Decode as Decode
import List.Extra


-- CONSTANTS


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
        , backgroundColor black
        ]
    , navbar = [ width (vw 200) ]
    , list =
        [ displayFlex
        , margin zero
        , padding2 (px 16) (px 8)
        , textAlign center
        ]
    , listItem =
        [ flex (num 1)
        ]
    , link = [ color white ]
    , navLink =
        [ position absolute
        , top (pct 50)
        , transform <| translateY (pct -50)
        ]
    , backLink = [ left zero ]
    , nextLink = [ right zero ]
    }



-- VIEW


view : List ( String, String, view ) -> view -> (view -> msg) -> Html msg
view links activeView changeView =
    let
        activeIndex =
            case List.Extra.findIndex (\( _, _, routeView ) -> routeView == activeView) links of
                Just index ->
                    index

                Nothing ->
                    -1

        backLink =
            case links |> List.take activeIndex |> List.head of
                Just route ->
                    viewLink route changeView Back

                Nothing ->
                    text ""

        nextLink =
            case links |> List.drop (activeIndex + 1) |> List.head of
                Just route ->
                    viewLink route changeView Next

                Nothing ->
                    text ""
    in
        header [ css styles.root ]
            [ nav [ css styles.navbar ]
                [ backLink
                , ul
                    [ css styles.list
                    , css [ transform <| translateX (pct <| toFloat <| -100 // List.length links * activeIndex) ]
                    ]
                  <|
                    List.map (toNavigationOption changeView) links
                , nextLink
                ]
            ]


viewLink : ( String, String, view ) -> (view -> msg) -> LinkVariant -> Html msg
viewLink ( url, label, routeView ) changeView variant =
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
             , onWithOptions "click" clickOptions <| Decode.succeed <| changeView routeView
             , css styles.link
             ]
                ++ variantStyles
            )
            [ text content ]



-- FUNCTIONS


toNavigationOption : (view -> msg) -> ( String, String, view ) -> Html msg
toNavigationOption changeView route =
    li [ css styles.listItem ] [ viewLink route changeView None ]
