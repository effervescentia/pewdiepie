module App exposing (..)

import Html exposing (Html, button, div, text, nav, a)
import Html.Events exposing (onClick)
import Navigation
import RouteUrl
import RouteUrl.Builder as Builder exposing (Builder)
import YouLaughYouLose
import MemeReview


-- MODEL


type ActiveView
    = MemeReview
    | YouLaughYouLose


type alias Model =
    { visited : Bool
    , activeView : ActiveView
    , memeReview : MemeReview.Model
    , youLaughYouLose : YouLaughYouLose.Model
    }


init : ( Model, Cmd Action )
init =
    ( Model False MemeReview MemeReview.init YouLaughYouLose.init
    , Cmd.none
    )



-- UPDATE


type Action
    = EnterSite
    | ChangeView ActiveView
    | MemeReviewAction MemeReview.Action
    | YouLaughYouLoseAction YouLaughYouLose.Action


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        EnterSite ->
            ( { model | visited = True }, Cmd.none )

        ChangeView view ->
            ( { model | activeView = view }, Cmd.none )

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
            case model.activeView of
                MemeReview ->
                    Html.map MemeReviewAction (MemeReview.view model.memeReview)

                YouLaughYouLose ->
                    Html.map YouLaughYouLoseAction (YouLaughYouLose.view model.youLaughYouLose)
    in
        div []
            [ nav []
                [ a [ onClick (ChangeView MemeReview) ] [ text "Meme Review" ]
                , a [ onClick (ChangeView YouLaughYouLose) ] [ text "You Laugh. You Lose." ]
                ]
            , div [] [ activeView ]
            ]



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
    case current.activeView of
        MemeReview ->
            MemeReview.delta2builder previous.memeReview current.memeReview
                |> Maybe.map (Builder.prependToPath [ "meme-review" ])

        YouLaughYouLose ->
            YouLaughYouLose.delta2builder previous.youLaughYouLose current.youLaughYouLose
                |> Maybe.map (Builder.prependToPath [ "you-laugh-you-lose" ])


builder2messages : Builder -> List Action
builder2messages builder =
    case Builder.path builder of
        first :: rest ->
            let
                subBuilder =
                    Builder.replacePath rest builder
            in
                case first of
                    "meme-review" ->
                        (ChangeView MemeReview) :: List.map MemeReviewAction (MemeReview.builder2messages subBuilder)

                    "you-laug-you-lose" ->
                        (ChangeView YouLaughYouLose) :: List.map YouLaughYouLoseAction (YouLaughYouLose.builder2messages subBuilder)

                    _ ->
                        [ ChangeView MemeReview ]

        _ ->
            [ ChangeView MemeReview ]
