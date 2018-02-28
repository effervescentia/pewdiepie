module Routing exposing (..)

import Html.Styled exposing (Html, div)
import RouteUrl.Builder as Builder exposing (Builder)


-- MODEL


type alias Model v =
    { activeView : v
    }


init : v -> Model v
init =
    Model



-- UPDATE


type Action v
    = ChangeView v


update : Action v -> Model v -> Model v
update action model =
    case action of
        ChangeView view ->
            { model | activeView = view }



-- VIEW


view : Model v -> (v -> Html a) -> Html a
view model handleView =
    let
        activeView =
            handleView model.activeView
    in
        div [] [ activeView ]



-- FUNCTIONS


type alias LocationHandler a =
    String -> Builder -> List a


builder2messages : a -> LocationHandler a -> Builder -> List a
builder2messages defaultRoute handleRoute builder =
    case Builder.path builder of
        first :: rest ->
            let
                subBuilder =
                    Builder.replacePath rest builder
            in
                handleRoute first subBuilder

        _ ->
            [ defaultRoute ]
