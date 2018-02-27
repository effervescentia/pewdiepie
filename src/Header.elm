module Header exposing (..)

import Html exposing (Html, nav, text, a)
import Html.Events exposing (onClick)


-- VIEW


view : List ( String, String, a ) -> Html a
view links =
    nav [] <| List.map (\( link, label, handler ) -> a [ onClick handler ] [ text label ]) links
