module Advanced.ExerciseDraw exposing (..)

import Browser
import Html exposing (Html, button, div, h1, img, p, pre, text)
import Html.Attributes exposing (height, src, style, width)
import Html.Events exposing (on)
import Html.Events.Extra.Mouse as Mouse
import Json.Decode exposing (Decoder)
import Svg exposing (Svg, circle, line, svg)
import Svg.Attributes exposing (cx, cy, r, x1, x2, y1, y2)


type alias Point =
    { x : Float, y : Float }


type alias Line =
    { from : Point, to : Point }


type alias Model =
    { lines : List Line
    , firstPointForNextLine : Maybe Point
    }


initialModel : Model
initialModel =
    { lines = []
    , firstPointForNextLine = Nothing
    }


type Msg
    = CanvasClickedAt Point


update : Msg -> Model -> Model
update msg model =
    case msg of
        CanvasClickedAt pointClicked ->
            case model.firstPointForNextLine of
                Just firstPoint ->
                    { model
                        | firstPointForNextLine = Nothing
                        , lines = { from = firstPoint, to = pointClicked } :: model.lines
                    }

                Nothing ->
                    { model | firstPointForNextLine = Just pointClicked }


view : Model -> Html Msg
view model =
    div [ style "padding" "1rem" ]
        [ h1 [] [ text "Draw lines!" ]
        , p [] [ text "Click at different spots in the frame below to draw lines." ]
        , svg
            [ style "border" "1px black solid"
            , width 800
            , height 400
            , Mouse.onClick
                (\event ->
                    CanvasClickedAt
                        { x = Tuple.first event.offsetPos
                        , y = Tuple.second event.offsetPos
                        }
                )
            ]
            (drawFirstPoint model.firstPointForNextLine :: List.map drawLine model.lines)
        ]


drawLine : Line -> Svg Msg
drawLine { from, to } =
    line
        [ x1 (String.fromFloat from.x)
        , y1 (String.fromFloat from.y)
        , x2 (String.fromFloat to.x)
        , y2 (String.fromFloat to.y)
        , Svg.Attributes.style "stroke:rgb(255,0,0);stroke-width:2"
        ]
        []


drawFirstPoint : Maybe Point -> Svg Msg
drawFirstPoint maybePoint =
    case maybePoint of
        Just point ->
            circle
                [ cx (String.fromFloat point.x)
                , cy (String.fromFloat point.y)
                , r "2"
                , Svg.Attributes.style "fill:rgb(255,0,0)"
                ]
                []

        Nothing ->
            circle [] []


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
