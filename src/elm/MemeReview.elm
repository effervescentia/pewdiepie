module MemeReview exposing (..)

import Css exposing (Style, absolute, alignItems, backgroundColor, center, column, displayFlex, flexDirection, height, int, justifyContent, margin, num, padding, pct, position, property, px, transform, translateX, width, zIndex, zero)
import Css.Colors exposing (black)
import Delay
import Html.Styled exposing (Html, button, div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css, type_)
import InlineSvg exposing (inline)
import Keyboard exposing (KeyCode)
import List.Extra
import Meme
import Memes exposing (memes)
import RouteUrl.Builder as Builder exposing (Builder, builder, query, replaceQuery)
import Slider
import Time exposing (millisecond)


-- CONSTANTS


route : String
route =
    "meme-review"


{ icon } =
    inline { spotlight = "../../assets/spotlight.svg" }



-- MODEL


type AnimationState
    = Sliding
    | AnimatingMeme Meme.Msg
    | Done


type alias Model =
    { sliderState : Slider.Context
    , animationState : AnimationState
    , memeState : Meme.Context
    }


init : Model
init =
    Model Slider.init Done Meme.initFinal



-- UPDATE


type Msg
    = ChangeMeme Int
    | UpdateSlide Int
    | HandleKeypress KeyCode
    | UpdateAnimation AnimationState
    | MemeMsg Meme.Msg
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update action ({ sliderState, memeState } as model) =
    let
        changeSlide index =
            if index /= sliderState.activeIndex then
                { model
                    | sliderState = { sliderState | activeIndex = index }
                    , memeState = Meme.init
                    , animationState = Sliding
                }
                    ! [ Delay.after 1000 millisecond <| UpdateAnimation <| AnimatingMeme <| Meme.AnimateStep Meme.ShowRating ]
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
                    AnimatingMeme memeMsg ->
                        case List.Extra.getAt sliderState.activeIndex memes of
                            Just activeMeme ->
                                let
                                    ( updatedState, cmd ) =
                                        Meme.update memeMsg memeState activeMeme
                                in
                                    ( { model | memeState = updatedState }, Cmd.map MemeMsg cmd )

                            Nothing ->
                                model ! []

                    _ ->
                        { model | animationState = animation } ! []

            MemeMsg memeMsg ->
                model ! []

            None ->
                model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
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


view : Model -> Html Msg
view { sliderState, animationState, memeState } =
    div [ css styles.root ]
        [ div [ css styles.spotlight ] [ fromUnstyled (icon .spotlight []) ]
        , div [ css styles.foreground ]
            [ Slider.view
                { activateIndex = ChangeMeme
                }
                sliderState
              <|
                List.map
                    (Meme.view
                        { updateAnimation = (\animation -> None)
                        }
                        memeState
                    )
                    Memes.memes
            ]
        ]



-- ROUTING


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    Just builder


builder2messages : Builder -> List Msg
builder2messages builder =
    []
