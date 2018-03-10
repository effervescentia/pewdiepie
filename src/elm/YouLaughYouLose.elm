module YouLaughYouLose exposing (..)

import Dict
import Html.Styled exposing (Html, button, div, text)
import Html.Styled.Attributes exposing (type_)
import Html.Styled.Events exposing (onClick)
import RouteUrl.Builder as Builder exposing (Builder, builder, query, replaceQuery)
import String exposing (toInt)


-- CONSTANTS


route : String
route =
    "you-laugh-you-lose"



-- MODEL


type alias Model =
    { laughed : Int
    , lost : Int
    }


init : Model
init =
    Model 0 0



-- UPDATE


type Msg
    = Laugh
    | Lose
    | SetCounts Int Int


update : Msg -> Model -> Model
update action model =
    case action of
        Laugh ->
            { model | laughed = model.laughed + 1 }

        Lose ->
            { model | lost = model.lost + 1 }

        SetCounts laughed lost ->
            { model | laughed = laughed, lost = lost }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ type_ "button", onClick Laugh ] [ text "Laugh" ]
        , text "You Laugh. You Lose."
        , button [ type_ "button", onClick Lose ] [ text "Lost" ]
        ]



-- ROUTING


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    builder
        |> replaceQuery [ ( "laughed", toString current.laughed ), ( "lost", toString current.lost ) ]
        |> Just


builder2messages : Builder -> List Msg
builder2messages builder =
    case query builder of
        queryParams ->
            let
                queryDict =
                    Dict.fromList queryParams
            in
                case ( Dict.get "laughed" queryDict, Dict.get "lost" queryDict ) of
                    ( Just laughed, Just lost ) ->
                        case ( toInt laughed, toInt lost ) of
                            ( Ok laugh, Ok lose ) ->
                                [ SetCounts laugh lose ]

                            _ ->
                                []

                    _ ->
                        []
