module Main exposing (main)

import App exposing (Msg, Model)
import Html.Styled exposing (toUnstyled)
import RouteUrl exposing (RouteUrlProgram)


main : RouteUrlProgram Never Model Msg
main =
    RouteUrl.program
        { delta2url = App.delta2url
        , location2messages = App.location2messages
        , init = App.init
        , view = App.view >> toUnstyled
        , update = App.update
        , subscriptions = App.subscriptions
        }
