module Header exposing (..)

import Css exposing (Style, backgroundColor, color)
import Css.Colors exposing (black, white)
import Html.Styled exposing (Html, a, header, li, nav, text, ul)
import Html.Styled.Attributes exposing (css, href, style)
import Html.Styled.Events as Events exposing (onWithOptions)
import Json.Decode as Decode


-- CONSTANTS


clickOptions : Events.Options
clickOptions =
    { preventDefault = True
    , stopPropagation = False
    }



-- STYLE


type alias Styles =
    { root : List Style
    , list : List Style
    , link : List Style
    }


styles : Styles
styles =
    { root = [ backgroundColor black ]
    , list = []
    , link = [ color white ]
    }



-- type alias Styles =
--     List ( String, String )
--
--
-- type alias StylesMap =
--     { root : Styles
--     , list : Styles
--     , link : Styles
--     }
--
--
-- styles : StylesMap
-- styles =
--     { root =
--         [ background "black"
--         ]
--     , list =
--         [ display "flex"
--         ]
--     , link = []
--     }
-- VIEW


view : List ( String, String, msg ) -> Html msg
view links =
    header [ css styles.root ]
        [ nav []
            [ ul [] <|
                List.map toNavigationOption links
            ]
        ]



-- FUNCTIONS


toNavigationOption : ( String, String, msg ) -> Html msg
toNavigationOption ( url, label, handler ) =
    li []
        [ a
            [ href <| "/" ++ url
            , onWithOptions "click" clickOptions <| Decode.succeed handler
            , css styles.link
            ]
            [ text label ]
        ]
