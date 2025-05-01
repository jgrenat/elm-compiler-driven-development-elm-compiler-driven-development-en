module Exercise017StyledHTML exposing (..)

import Html exposing (li, text, ul)
import Html.Attributes exposing (id, style)


main =
    ul []
        [ li [ style "color" "red" ] [ text "This text is red" ]
        , li [ id "greenText", style "color-green" ] [ text "This text is green (hopefully)" ]
        ]
