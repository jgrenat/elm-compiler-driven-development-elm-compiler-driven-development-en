module Exercise014Signatures exposing (..)

import Html exposing (div, text)


add : Int -> Int -> Int
add a b =
    a + b


multiply : Int
multiply a b =
    a * b


main =
    div []
        [ div [] [ text ("5 plus 6 equals " ++ String.fromInt (add 5 6)) ]
        , div [] [ text ("5 times 6 equals " ++ String.fromInt (multiply 5 6)) ]
        ]
