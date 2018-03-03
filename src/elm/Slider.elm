module Slider exposing (..)

import Html.Styled exposing (Html, button, div, li, text, ul)
import Html.Styled.Events exposing (onClick)


-- MODEL


type alias Context =
    { activeIndex : Int
    }


type alias Config msg =
    { activateIndex : Int -> msg
    }



-- VIEW


view : Config msg -> Context -> List (Html msg) -> Html msg
view { activateIndex } { activeIndex } options =
    let
        backButton =
            if activeIndex > 0 then
                button [ onClick (activateIndex <| activeIndex - 1) ] []
            else
                text ""

        nextButton =
            if activeIndex < List.length (options) - 1 then
                button [ onClick (activateIndex <| activeIndex + 1) ] []
            else
                text ""
    in
        div []
            [ ul [] <| List.map (\el -> li [] [ el ]) options
            , backButton
            , nextButton
            ]



-- conditionalButton : List (Route view) -> Int -> LinkVariant -> (view -> msg) -> Html msg
-- conditionalButton links activeIndex variant changeView =
--     case List.head links of
--         Just route ->
--             viewLink route changeView variant
--
--         Nothing ->
--             text ""
--
--
-- viewLink : Route routeView -> (routeView -> msg) -> LinkVariant -> Html msg
-- viewLink { url, label, view } changeView variant =
--     let
--         ( content, variantStyles ) =
--             case variant of
--                 None ->
--                     ( label, [] )
--
--                 Next ->
--                     ( ">", [ css styles.navLink, css styles.nextLink ] )
--
--                 Back ->
--                     ( "<", [ css styles.navLink, css styles.backLink ] )
--     in
--         a
--             ([ href <| "/" ++ url
--              , onWithOptions "click" clickOptions <| Decode.succeed <| changeView view
--              , css styles.link
--              ]
--                 ++ variantStyles
--             )
--             [ text content ]
