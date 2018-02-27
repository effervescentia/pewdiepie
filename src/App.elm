module App exposing (..)

import Html exposing (Html, button, div, text, nav, a)
import Html.Events exposing (onClick)
import RouteUrl.Builder as Builder exposing (Builder)
import Navigation
import RouteUrl
import YouLaughYouLose
import MemeReview
import Routing


-- MODEL


type View
    = MemeReview
    | YouLaughYouLose


type alias Model =
    { visited : Bool
    , memeReview : MemeReview.Model
    , youLaughYouLose : YouLaughYouLose.Model
    , routing : Routing.Model View
    }


type RouteModel
    = MemeReviewModel MemeReview.Model
    | YouLaughYouLoseModel YouLaughYouLose.Model


init : ( Model, Cmd Action )
init =
    ( Model False MemeReview.init YouLaughYouLose.init <| Routing.init MemeReview
    , Cmd.none
    )



-- UPDATE


type Action
    = EnterSite
    | RoutingAction (Routing.Action View)
    | MemeReviewAction MemeReview.Action
    | YouLaughYouLoseAction YouLaughYouLose.Action


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        EnterSite ->
            ( { model | visited = True }, Cmd.none )

        RoutingAction subaction ->
            ( { model | routing = Routing.update subaction model.routing }, Cmd.none )

        MemeReviewAction subaction ->
            ( { model | memeReview = MemeReview.update subaction model.memeReview }, Cmd.none )

        YouLaughYouLoseAction subaction ->
            ( { model | youLaughYouLose = YouLaughYouLose.update subaction model.youLaughYouLose }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Action
view model =
    let
        activeView =
            Routing.view model.routing <| viewRoute model
    in
        div []
            [ nav []
                [ a [ onClick (RoutingAction <| Routing.ChangeView MemeReview) ] [ text "Meme Review" ]
                , a [ onClick (RoutingAction <| Routing.ChangeView YouLaughYouLose) ] [ text "You Laugh. You Lose." ]
                ]
            , div [] [ activeView ]
            ]


viewRoute : Model -> View -> Html Action
viewRoute model view =
    case view of
        MemeReview ->
            Html.map MemeReviewAction (MemeReview.view model.memeReview)

        YouLaughYouLose ->
            Html.map YouLaughYouLoseAction (YouLaughYouLose.view model.youLaughYouLose)



-- ROUTING


delta2url : Model -> Model -> Maybe RouteUrl.UrlChange
delta2url previous current =
    Maybe.map Builder.toUrlChange <| delta2builder previous current


location2messages : Navigation.Location -> List Action
location2messages location =
    builder2messages (Builder.fromUrl location.href)



-- FUNCTIONS


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    case current.routing.activeView of
        MemeReview ->
            MemeReview.delta2builder previous.memeReview current.memeReview
                |> Maybe.map (Builder.prependToPath [ "meme-review" ])

        YouLaughYouLose ->
            YouLaughYouLose.delta2builder previous.youLaughYouLose current.youLaughYouLose
                |> Maybe.map (Builder.prependToPath [ "you-laugh-you-lose" ])


builder2messages : Builder -> List Action
builder2messages =
    Routing.builder2messages (RoutingAction <| Routing.ChangeView MemeReview) handleLocation


handleLocation : Routing.LocationHandler Action
handleLocation path builder =
    case path of
        "meme-review" ->
            (RoutingAction <| Routing.ChangeView MemeReview) :: List.map MemeReviewAction (MemeReview.builder2messages builder)

        "you-laugh-you-lose" ->
            (RoutingAction <| Routing.ChangeView YouLaughYouLose) :: List.map YouLaughYouLoseAction (YouLaughYouLose.builder2messages builder)

        _ ->
            [ RoutingAction <| Routing.ChangeView MemeReview ]
