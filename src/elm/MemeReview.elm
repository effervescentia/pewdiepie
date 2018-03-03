module MemeReview exposing (..)

import Css exposing (Style, absolute, alignItems, backgroundColor, center, column, displayFlex, flexDirection, height, int, justifyContent, margin, num, padding, pct, position, property, px, transform, translateX, width, zIndex, zero)
import Css.Colors exposing (black)
import Html.Styled exposing (Html, button, div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css, type_)
import InlineSvg exposing (inline)
import Keyboard exposing (KeyCode)
import Meme
import Memes exposing (memes)
import RouteUrl.Builder as Builder exposing (Builder, builder, query, replaceQuery)
import Slider


-- CONSTANTS


{ icon } =
    inline { spotlight = "../../assets/spotlight.svg" }



-- MODEL


type alias Model =
    { activeIndex : Int
    }


init : Model
init =
    Model 0



-- UPDATE


type Action
    = ChangeMeme Int
    | HandleKeypress KeyCode


update : Action -> Model -> Model
update action model =
    case action of
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


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    Just builder


builder2messages : Builder -> List Action
builder2messages builder =
    []
