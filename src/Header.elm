module Header exposing (..)

import Element exposing (Element, el, link, text)
import Element.Events as Events exposing (defaultOptions)
import Html exposing (Html)
import Json.Decode as Decode
import Style


-- STYLE


type Classes
    = Root
    | Link


stylesheet : Style.StyleSheet Classes variation
stylesheet =
    Style.styleSheet
        [ Style.style Link []
        ]



-- VIEW


view : List ( String, String, msg ) -> Html msg
view links =
    Html.header []
        [ Html.nav [] <|
            List.map viewLink links
        ]


viewLink : ( String, String, msg ) -> Html msg
viewLink ( url, label, handler ) =
    let
        options =
            { preventDefault = True
            , stopPropagation = False
            }

        decode =
            Decode.succeed handler
    in
        Element.layout stylesheet <|
            link url <|
                el Link [ Events.onWithOptions "click" options decode ] (text label)
