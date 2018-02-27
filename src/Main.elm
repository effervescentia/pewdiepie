module Main exposing (main)

import App exposing (Model, Action)
import RouteUrl exposing (RouteUrlProgram)


main : RouteUrlProgram Never Model Action
main =
    RouteUrl.program
        { delta2url = App.delta2url
        , location2messages = App.location2messages
        , init = App.init
        , view = App.view
        , update = App.update
        , subscriptions = (\_ -> Sub.none)
        }
