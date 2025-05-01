module Exercise027Time exposing (..)

import Browser
import Html exposing (..)
import Task
import Time



-- We want to display the current time. To do this, we need to "subscribe" to the current time:
-- the runtime will regularly send messages containing the current time (in the form of a
-- timestamp/Posix).
--
-- Once again, this protects us from the outside world 😷.


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { zone = Time.utc, time = Time.millisToPosix 0 }
    , -- Elm forces us to handle the time zone separately from the time itself, which helps us avoid
      -- many common pitfalls related to time handling (see https://gist.github.com/timvisee/fcda9bbdff88d45cc9061606b4b923ca).
      --
      -- This command retrieves the user's time zone:
      Task.perform TimeZoneReceived Time.here
    )


type Msg
    = Tick Time.Posix
    | TimeZoneReceived Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        TimeZoneReceived newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    -- But how do we specify that we want to generate a `Tick` message every 1000 milliseconds?
    Time.every 1000


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
