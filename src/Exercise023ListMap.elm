module Exercise023ListMap exposing (..)

import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)


type alias Model =
    { shapes : List Shape }


type Shape
    = Square Float
    | Circle Float


initialModel : Model
initialModel =
    { shapes = [ Square 50 ] }


type Msg
    = AddShape Shape


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddShape shape ->
            { model | shapes = shape ++ model.shapes }


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick (AddShape (Square 50)), style "margin-right" "1em" ] [ text "Add a square" ]
            , button [ onClick (AddShape (Circle 50)) ] [ text "Add a circle" ]
            ]
        , div [ style "padding" "1rem", style "display" "flex" ]
            (List.map viewShape)
        ]


viewShape : Shape -> Html Msg
viewShape shape =
    case shape of
        Square side ->
            div
                [ style "width" (floatToPixels side)
                , style "height" (floatToPixels side)
                , style "background-color" "blue"
                , style "margin-right" "1em"
                ]
                []

        Circle radius ->
            div
                [ style "width" (floatToPixels radius)
                , style "height" (floatToPixels radius)
                , style "background-color" "green"
                , style "border-radius" "50%"
                , style "margin-right" "1em"
                ]
                []


floatToPixels : Float -> String
floatToPixels float =
    String.fromFloat float ++ "px"


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
