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


init : ( Model, Cmd Msg )
init =
    let
        ( memeReviewState, memeReviewCmd ) =
            MemeReview.init
    in
        ( Model False memeReviewState YouLaughYouLose.init (Routing.init MemeReview)
        , Cmd.map MemeReviewMsg memeReviewCmd
        )



-- UPDATE


type Msg
    = EnterSite
    | RoutingMsg (Routing.Msg View)
    | MemeReviewMsg MemeReview.Msg
    | YouLaughYouLoseMsg YouLaughYouLose.Msg


changeView : View -> Msg
changeView view =
    RoutingMsg <| Routing.ChangeView view


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EnterSite ->
            { model | visited = True } ! []

        RoutingMsg routingMsg ->
            { model | routing = Routing.update routingMsg model.routing } ! []

        MemeReviewMsg memeReviewMsg ->
            let
                ( updatedModel, cmd ) =
                    MemeReview.update memeReviewMsg model.memeReview
            in
                ( { model | memeReview = updatedModel }, Cmd.map MemeReviewMsg cmd )

        YouLaughYouLoseMsg ylylMsg ->
            { model | youLaughYouLose = YouLaughYouLose.update ylylMsg model.youLaughYouLose } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch <|
        case model.routing.activeView of
            MemeReview ->
                [ Sub.map MemeReviewMsg <| MemeReview.subscriptions model.memeReview
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


view : Model -> Html Msg
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


viewRoute : Model -> View -> Html Msg
viewRoute model view =
    case view of
        MemeReview ->
            Html.map MemeReviewMsg <| MemeReview.view model.memeReview

        YouLaughYouLose ->
            Html.map YouLaughYouLoseMsg <| YouLaughYouLose.view model.youLaughYouLose



-- ROUTING


delta2url : Model -> Model -> Maybe RouteUrl.UrlChange
delta2url previous current =
    Maybe.map Builder.toUrlChange <| delta2builder previous current


location2messages : Navigation.Location -> List Msg
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


builder2messages : Builder -> List Msg
builder2messages =
    Routing.builder2messages (changeView MemeReview) handleLocation


handleLocation : Routing.LocationHandler Msg
handleLocation path builder =
    case path of
        "meme-review" ->
            (changeView MemeReview) :: List.map MemeReviewMsg (MemeReview.builder2messages builder)

        "you-laugh-you-lose" ->
            (changeView YouLaughYouLose) :: List.map YouLaughYouLoseMsg (YouLaughYouLose.builder2messages builder)

        _ ->
            [ changeView MemeReview ]
