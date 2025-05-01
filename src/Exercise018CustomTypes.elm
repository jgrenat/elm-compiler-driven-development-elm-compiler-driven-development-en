module Exercise018CustomTypes exposing (..)

import Html exposing (li, text, ul)
import Html.Attributes exposing (id, style)


type Color
    = Red
    | Green


main =
    ul []
        [ li [ style "color" (colorToString Red) ] [ text "This text is red" ]
        , li [ style "color" (colorToString Green) ] [ text "This text is green (hopefully)" ]
        ]


colorToString : Color -> String
colorToString color =
    case color of
        Red ->
            "red"
