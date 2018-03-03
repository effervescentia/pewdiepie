module App exposing (..)

import Css exposing (Style, backgroundColor, height, hidden, overflowY, pct, width)
import Css.Colors exposing (black, blue)
import Header exposing (Route)
import Html.Styled as Html exposing (Html, a, button, div, main_, nav, text)
import Html.Styled.Attributes exposing (css)
import MemeReview
import Navigation
import RouteUrl
import RouteUrl.Builder as Builder exposing (Builder)
import Routing
import YouLaughYouLose


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



-- STYLE


type alias Styles =
    { root : List Style
    , main : List Style
    }


styles : Styles
styles =
    { root =
        [ height (pct 100)
        , overflowY hidden
        ]
    , main =
        [ height (pct 100) ]
    }



-- VIEW


view : Model -> Html Action
view model =
    let
        handleRoute view =
            RoutingAction <| Routing.ChangeView view

        header =
            Header.view
                [ Route MemeReview "meme-review" "Meme Review" [ backgroundColor black ]

                -- , Route YouLaughYouLose "you-laugh-you-lose" "You Laugh. You Lose." [ backgroundColor blue ]
                ]
                model.routing.activeView
                handleRoute

        activeView =
            Routing.view model.routing <| viewRoute model
    in
        div [ css styles.root ]
            [ header
            , main_ [ css styles.main ] [ activeView ]
            ]


viewRoute : Model -> View -> Html Action
viewRoute model view =
    case view of
        MemeReview ->
            Html.map MemeReviewAction <| MemeReview.view model.memeReview

        YouLaughYouLose ->
            Html.map YouLaughYouLoseAction <| YouLaughYouLose.view model.youLaughYouLose



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
