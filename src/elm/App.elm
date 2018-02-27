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
    ( Model False MemeReview.init YouLaughYouLose.init (Routing.init MemeReview)
    , Cmd.none
    )



-- UPDATE


type Action
    = EnterSite
    | RoutingAction (Routing.Action View)
    | MemeReviewAction MemeReview.Action
    | YouLaughYouLoseAction YouLaughYouLose.Action


changeView : View -> Action
changeView view =
    RoutingAction <| Routing.ChangeView view


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        EnterSite ->
            { model | visited = True } ! []

        RoutingAction subaction ->
            { model | routing = Routing.update subaction model.routing } ! []

        MemeReviewAction subaction ->
            let
                ( updatedModel, cmd ) =
                    MemeReview.update subaction model.memeReview
            in
                ( { model | memeReview = updatedModel }, Cmd.map MemeReviewAction cmd )

        YouLaughYouLoseAction subaction ->
            { model | youLaughYouLose = YouLaughYouLose.update subaction model.youLaughYouLose } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.batch <|
        case model.routing.activeView of
            MemeReview ->
                [ Sub.map MemeReviewAction <| MemeReview.subscriptions model.memeReview
                ]

            _ ->
                []



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
        header =
            Header.view
                [ Route MemeReview MemeReview.route "Meme Review" [ backgroundColor black ]

                -- , Route YouLaughYouLose "you-laugh-you-lose" "You Laugh. You Lose." [ backgroundColor blue ]
                ]
                model.routing.activeView
                changeView

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
                |> Maybe.map (Builder.prependToPath [ MemeReview.route ])

        YouLaughYouLose ->
            YouLaughYouLose.delta2builder previous.youLaughYouLose current.youLaughYouLose
                |> Maybe.map (Builder.prependToPath [ YouLaughYouLose.route ])


builder2messages : Builder -> List Action
builder2messages =
    Routing.builder2messages (changeView MemeReview) handleLocation


handleLocation : Routing.LocationHandler Action
handleLocation path builder =
    case path of
        "meme-review" ->
            (changeView MemeReview) :: List.map MemeReviewAction (MemeReview.builder2messages builder)

        "you-laugh-you-lose" ->
            (changeView YouLaughYouLose) :: List.map YouLaughYouLoseAction (YouLaughYouLose.builder2messages builder)

        _ ->
            [ changeView MemeReview ]
