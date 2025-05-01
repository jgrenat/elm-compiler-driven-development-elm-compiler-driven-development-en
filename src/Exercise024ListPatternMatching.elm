module Exercise024ListPatternMatching exposing (..)

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
    | RemoveShape


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddShape shape ->
            { model | shapes = shape :: model.shapes }

        RemoveShape ->
            case model.shapes of
                firstShape :: otherShapes ->
                    { model | shapes = otherShapes }


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick (AddShape (Square 50)), style "margin-right" "1em" ] [ text "Add a square" ]
            , button [ onClick (AddShape (Circle 50)), style "margin-right" "1em" ] [ text "Add a circle" ]
            , button [ onClick RemoveShape ] [ text "Remove last added shape" ]
            ]
        , div [ style "padding" "1rem", style "display" "flex" ]
            (List.map viewShape model.shapes)
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
