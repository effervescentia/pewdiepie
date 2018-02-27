module MemeReview exposing (..)

import Css exposing (Style, absolute, alignItems, backgroundColor, center, column, displayFlex, flexDirection, height, int, justifyContent, margin, num, padding, pct, position, property, px, transform, translateX, width, zIndex, zero)
import Css.Colors exposing (black)
import Html.Styled exposing (Html, button, div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css, type_)
import InlineSvg exposing (inline)
import Keyboard exposing (KeyCode)
import Meme exposing (AnimationState, AnimationState(ShowRating, Finished))
import Memes exposing (memes)
import RouteUrl.Builder as Builder exposing (Builder, builder, query, replaceQuery)
import Slider
import Transit


-- CONSTANTS


route : String
route =
    "meme-review"


{ icon } =
    inline { spotlight = "../../assets/spotlight.svg" }



-- MODEL


type AnimationState
    = Sliding
    | AnimatingMeme Meme.AnimationState
    | Done


type alias Model =
    { activeIndex : Int
    , animationState : AnimationState
    , memeState : Meme.Context
    }


init : Model
init =
    Model 0 Done Meme.init



-- UPDATE


type Action
    = ChangeMeme Int
    | HandleKeypress KeyCode
    | UpdateAnimation AnimationState
    | None


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        ChangeMeme index ->
            { model | activeIndex = index } ! []

        HandleKeypress code ->
            case model.animationState of
                Sliding ->
                    model ! []

                _ ->
                    let
                        updateActiveIndex index =
                            { model
                                | activeIndex = Debug.log "next page" index
                                , animationState = Sliding
                                , memeState = Meme.init
                            }
                                ! []
                    in
                        case code of
                            -- left arrow
                            37 ->
                                let
                                    newIndex =
                                        max 0 (model.activeIndex - 1)
                                in
                                    if newIndex /= model.activeIndex then
                                        updateActiveIndex newIndex
                                    else
                                        model ! []

                            -- right arrow
                            39 ->
                                let
                                    newIndex =
                                        min (List.length memes - 1) (model.activeIndex + 1)
                                in
                                    if newIndex /= model.activeIndex then
                                        updateActiveIndex newIndex
                                    else
                                        model ! []

                            _ ->
                                model ! []

        UpdateAnimation animation ->
            case animation of
                AnimatingMeme memeAnimation ->
                    let
                        memeState =
                            Meme.update memeAnimation
                    in
                        case memeState.animationState of
                            Finished ->
                                { model
                                    | animationState = Done
                                    , memeState = memeState
                                }
                                    ! []

                            _ ->
                                { model
                                    | animationState = animation
                                    , memeState = memeState
                                }
                                    ! []

                _ ->
                    { model | animationState = animation } ! []

        None ->
            model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.batch [ Keyboard.ups HandleKeypress ]



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
view { activeIndex, animationState, memeState } =
    div [ css styles.root ]
        [ div [ css styles.spotlight ] [ fromUnstyled (icon .spotlight []) ]
        , div [ css styles.foreground ]
            [ Slider.view
                { activateIndex = ChangeMeme
                , completeTransition =
                    (if animationState == Sliding then
                        UpdateAnimation <| AnimatingMeme ShowRating
                     else
                        None
                    )
                }
                { activeIndex = activeIndex }
              <|
                List.map
                    (Meme.view
                        { updateAnimation = \animation -> UpdateAnimation <| AnimatingMeme animation }
                        memeState
                    )
                    Memes.memes
            ]
        ]



-- ROUTING


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    Just builder


builder2messages : Builder -> List Action
builder2messages builder =
    []
