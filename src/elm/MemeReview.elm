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
    { sliderState : Slider.Context
    , animationState : AnimationState
    , memeState : Meme.Context
    }


init : Model
init =
    Model Slider.init Done Meme.init



-- UPDATE


type Msg
    = ChangeMeme Int
    | UpdateSlide Int
    | HandleKeypress KeyCode
    | UpdateAnimation AnimationState
    | TransitMsg (Transit.Msg Msg)
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update action ({ sliderState } as model) =
    let
        changeSlide index =
            if index /= sliderState.activeIndex then
                let
                    ( updatedState, cmd ) =
                        Transit.start TransitMsg
                            (UpdateSlide <| Debug.log "next page" index)
                            ( 1000, 0 )
                            sliderState
                in
                    ( { model
                        | sliderState = updatedState
                        , memeState = Meme.init
                        , animationState = Sliding
                      }
                    , cmd
                    )
            else
                model ! []
    in
        case action of
            ChangeMeme index ->
                changeSlide index

            HandleKeypress code ->
                case code of
                    -- left arrow
                    37 ->
                        let
                            newIndex =
                                max 0 (sliderState.activeIndex - 1)
                        in
                            changeSlide newIndex

                    -- right arrow
                    39 ->
                        let
                            newIndex =
                                min (List.length memes - 1) (sliderState.activeIndex + 1)
                        in
                            changeSlide newIndex

                    _ ->
                        model ! []

            UpdateSlide index ->
                { model | sliderState = { sliderState | activeIndex = index } } ! []

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

            TransitMsg transitMsg ->
                let
                    ( updatedState, cmd ) =
                        Transit.tick TransitMsg transitMsg sliderState
                in
                    ( { model | sliderState = updatedState }, cmd )

            None ->
                model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.ups HandleKeypress
        , Transit.subscriptions TransitMsg model.sliderState
        ]



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


view : Model -> Html Msg
view { sliderState, animationState, memeState } =
    div [ css styles.root ]
        [ div [ css styles.spotlight ] [ fromUnstyled (icon .spotlight []) ]
        , div [ css styles.foreground ]
            [ Slider.view
                { activateIndex = ChangeMeme

                -- , completeTransition =
                --     (if animationState == Sliding then
                --         UpdateAnimation <| AnimatingMeme ShowRating
                --      else
                --         None
                --     )
                }
                sliderState
              <|
                List.map
                    (Meme.view
                        { updateAnimation = \animation -> UpdateAnimation <| AnimatingMeme animation
                        }
                        { memeState | animationsEnabled = Transit.getStep sliderState.transition == Transit.Done }
                    )
                    Memes.memes
            ]
        , text <| toString <| Transit.getValue sliderState.transition
        ]



-- ROUTING


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    Just builder


builder2messages : Builder -> List Msg
builder2messages builder =
    []
