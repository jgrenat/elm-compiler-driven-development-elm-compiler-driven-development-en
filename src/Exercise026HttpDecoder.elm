module Exercise026HttpDecoder exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder)


type Model
    = Failure String
    | Loading
    | Success Cat


type alias Cat =
    { title : String
    , url : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomCatGif )


type Msg
    = CatButtonClicked
    | GifReceived (Result Http.Error Cat)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CatButtonClicked ->
            ( Loading, getRandomCatGif )

        GifReceived result ->
            case result of
                Ok cat ->
                    ( Success cat, Cmd.none )

                Err error ->
                    case error of
                        Http.BadBody errorMsg ->
                            ( Failure errorMsg, Cmd.none )

                        _ ->
                            ( Failure "Http error!", Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Cats" ]
        , viewGif model
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure errorMsg ->
            div []
                [ text ("An error occurred: " ++ errorMsg)
                , button [ onClick CatButtonClicked ] [ text "Try again!" ]
                ]

        Loading ->
            text "Loading..."

        Success cat ->
            div []
                [ h1 [] [ text cat.title ]
                , button [ onClick CatButtonClicked, style "display" "block" ] [ text "Another one!" ]
                , img [ src cat.url ] []
                ]


getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=kOZdCy0KDR2n8Y83kawP0zdqUMqpHYRj&tag=cat"
        , expect = Http.expectJson GifReceived gifDecoder
        }


gifDecoder : Decoder Cat
gifDecoder =
    -- Elm can't guess the shape of the JSON we receive, so we need to tell it which fields
    -- we're interested in using this decoder.
    --
    -- The JSON looks like this:
    -- {
    --   "data": {
    --     "title": "Tired cat",
    --     "images" : { "original": { "url" : "http://...", ...}, ...},
    --     ...,
    --   },
    --   ...,
    -- }
    --
    -- You can see the full structure at the following link:
    -- https://api.giphy.com/v1/gifs/random?api_key=kOZdCy0KDR2n8Y83kawP0zdqUMqpHYRj&tag=cat
    Json.Decode.map2 Cat
        (Json.Decode.at [ "data", "title" ] Json.Decode.int)
        (Json.Decode.at [ "data", "images", "original", "url" ] Json.Decode.string)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- Inspired by:
-- https://elm-lang.org/examples/cat-gifs
