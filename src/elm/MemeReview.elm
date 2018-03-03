module MemeReview exposing (..)

import Css exposing (Style, absolute, alignItems, backgroundColor, center, column, displayFlex, flexDirection, height, int, justifyContent, margin, num, padding, pct, position, property, px, transform, translateX, width, zIndex, zero)
import Css.Colors exposing (black)
import Dict
import Html.Styled exposing (Html, button, div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css, type_)
import InlineSvg exposing (inline)
import Keyboard exposing (KeyCode)
import Meme
import Memes exposing (memes)
import RouteUrl.Builder as Builder exposing (Builder, builder, query, replaceQuery)
import Slider
import String exposing (toInt)


-- CONSTANTS


{ icon } =
    inline { spotlight = "../../assets/spotlight.svg" }



-- MODEL


type alias Model =
    { laughed : Int
    , lost : Int
    , activeIndex : Int
    }


init : Model
init =
    Model 0 0 0



-- UPDATE


type Action
    = Laugh
    | Lose
    | SetCounts Int Int
    | ChangeMeme Int
    | HandleKeypress KeyCode


update : Action -> Model -> Model
update action model =
    case action of
        Laugh ->
            { model | laughed = model.laughed + 1 }

        Lose ->
            { model | lost = model.lost + 1 }

        SetCounts laughed lost ->
            { model | laughed = laughed, lost = lost }

        ChangeMeme index ->
            { model | activeIndex = index }

        HandleKeypress code ->
            case code of
                -- left arrow
                37 ->
                    { model | activeIndex = max 0 (model.activeIndex - 1) }

                -- right arrow
                39 ->
                    { model | activeIndex = min (List.length memes - 1) (model.activeIndex + 1) }

                _ ->
                    model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.batch [ Keyboard.downs HandleKeypress ]



-- STYLE


type alias Styles =
    { root : List Style
    , spotlight : List Style
    , content : List Style
    , foreground : List Style
    }


styles : Styles
styles =
    { root =
        [ displayFlex
        , height (pct 100)
        , flexDirection column
        , justifyContent center
        , alignItems center
        , backgroundColor black
        ]
    , spotlight =
        [ position absolute
        , height (px 400)
        , width (px 400)
        , property "filter" "blur(200px)"
        , property "pointer-events" "none"
        ]
    , content =
        [ displayFlex
        , justifyContent center
        ]
    , foreground =
        [ displayFlex
        , height (pct 100)
        , width (pct 100)
        , flexDirection column
        , alignItems center
        , zIndex (int 100)
        ]
    }



-- VIEW


view : Model -> Html Action
view { activeIndex } =
    div [ css styles.root ]
        [ div [ css styles.spotlight ] [ fromUnstyled (icon .spotlight []) ]
        , div [ css styles.foreground ]
            [ Slider.view { activateIndex = ChangeMeme }
                { activeIndex = activeIndex }
              <|
                List.map
                    Meme.view
                    Memes.memes
            ]
        ]



-- ROUTING
-- needed to set the url when routing


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    builder
        |> replaceQuery
            [ ( "laughed", toString current.laughed )
            , ( "lost", toString current.lost )
            ]
        |> Just



-- only needed if I want the component to set its state from the URL


builder2messages : Builder -> List Action
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
