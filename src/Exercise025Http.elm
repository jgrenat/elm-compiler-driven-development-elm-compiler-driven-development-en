module Exercise025Http exposing (..)

import Browser
import Html exposing (Html, button, div, img, pre, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Http



-- Until now, our programs have been fairly simple and didn't depend on the outside world.
--
-- In Elm, the outside world is considered "dangerous": what happens when a network request
-- fails? Or returns an unexpected format?
--
-- So we delegate this task to the _runtime_, which protects us and forces us to handle such errors
-- (in Elm, protective measures are always on 😷).
--
-- To perform an HTTP request, we use the concept of a "command": our update function now returns
-- the new model AND a command to execute (in our case, an HTTP request).
--
-- The runtime performs the request, then returns the result to us in a message (in our case, `QuoteFetched`).


type alias Model =
    { quote : String }


initialModel : Model
initialModel =
    { quote = "Click on any button to load a quote 😉" }


type Msg
    = QuoteButtonClicked String
      -- The HTTP request can fail, which is why we receive a `Result` that contains either an error (`Http.Error`) or a quote (`String`).
    | QuoteFetched (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        QuoteButtonClicked url ->
            ( { model | quote = "Loading..." }, Http.get { expect = Http.expectString QuoteFetched } )

        QuoteFetched result ->
            case result of
                Err error ->
                    ( { model | quote = "Error! 😱" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick (QuoteButtonClicked "/resources/quote-1.txt"), style "margin-right" "1em" ] [ text "Get quote 1" ]
            , button [ onClick (QuoteButtonClicked "/resources/quote-2.txt"), style "margin-right" "1em" ] [ text "Get quote 2" ]
            , button [ onClick (QuoteButtonClicked "/resources/quote-3.txt") ] [ text "Get quote 3" ]
            ]
        , pre
            [ style "padding" "10px"
            , style "border" "1px solid gray"
            , style "max-width" "500px"
            , style "white-space" "pre-wrap"
            , style "margin" "10px"
            ]
            [ text model.quote ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
