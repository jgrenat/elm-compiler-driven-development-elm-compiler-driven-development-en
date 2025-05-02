module Advanced.ExerciseMemoryGame exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (disabled, style)
import Html.Events exposing (onClick)
import Random
import Random.List as Random
import Time


type alias Model =
    { state : State
    , cards : Maybe (List Card)
    , matched : List Card
    }


type State
    = Hidden
    | OneRevealed Card
    | TwoRevealed Card Card
    | Solved


type Card
    = Card Emoji Instance


type Instance
    = A
    | B


type Msg
    = Click Card
    | TimeOut
    | NewGame (List Card)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, newGame numPairsInit )


numPairsInit : Int
numPairsInit =
    3


initialModel : Model
initialModel =
    { state = Hidden
    , cards = Nothing
    , matched = []
    }


newGame : Int -> Cmd Msg
newGame numPairs =
    Random.generate
        NewGame
        (Random.shuffle emojisList
            |> Random.andThen
                (\code ->
                    createCards code numPairs
                        |> Random.shuffle
                )
        )


createCards : List Emoji -> Int -> List Card
createCards emojis numPairs =
    List.take numPairs emojis
        |> List.concatMap (\emoji -> [ Card emoji A, Card emoji B ])


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeOut ->
            ( case model.state of
                TwoRevealed _ _ ->
                    { model | state = Hidden }

                _ ->
                    model
            , Cmd.none
            )

        Click card ->
            ( if List.member card model.matched then
                model

              else
                case model.state of
                    Hidden ->
                        { model | state = OneRevealed card }

                    OneRevealed card1 ->
                        revealAnother model card1 card

                    _ ->
                        model
            , Cmd.none
            )

        NewGame cards ->
            ( { model | cards = Just cards }
            , Cmd.none
            )


revealAnother : Model -> Card -> Card -> Model
revealAnother model alreadyRevealed toReveal =
    if toReveal == alreadyRevealed then
        model

    else
        let
            matched : List Card
            matched =
                if matching numPairsInit alreadyRevealed toReveal then
                    alreadyRevealed :: toReveal :: model.matched

                else
                    model.matched
        in
        { model
            | state =
                if List.length matched == numPairsInit * 2 then
                    Solved

                else
                    TwoRevealed alreadyRevealed toReveal
            , matched = matched
        }


matching : Int -> Card -> Card -> Bool
matching numPairs card1 card2 =
    case ( card1, card2 ) of
        ( Card index1 _, Card index2 _ ) ->
            index1 == index2


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.state of
        TwoRevealed _ _ ->
            Time.every 1000 (always TimeOut)

        _ ->
            Sub.none


view : Model -> Html Msg
view model =
    case model.cards of
        Just cards ->
            let
                numCards : Int
                numCards =
                    List.length cards

                columns : Int
                columns =
                    numColumns numCards

                rows : Int
                rows =
                    numCards // columns
            in
            Html.div []
                [ header model
                , Html.div
                    (grid rows columns)
                    (List.map
                        (cardView model.matched model.state)
                        cards
                    )
                ]

        Nothing ->
            Html.span messageStyle [ Html.text "Shuffling …" ]


{-| Try for equal number of rows and columns,
favoring more columns if numCards is not a perfect square
-}
numColumns : Int -> Int
numColumns numCards =
    Maybe.withDefault numCards
        (List.filter
            (\n -> modBy n numCards == 0)
            (List.range
                (numCards
                    |> toFloat
                    |> sqrt
                    |> ceiling
                )
                numCards
            )
            |> List.head
        )


header : Model -> Html Msg
header model =
    Html.div [ style "padding" "10px" ]
        (case model.state of
            Solved ->
                [ Html.span messageStyle [ Html.text "Congrats!" ]
                , Html.div []
                    [ Html.span messageStyle
                        [ Html.text "Play again?" ]
                    ]
                ]

            TwoRevealed card1 card2 ->
                [ Html.span messageStyle
                    [ Html.text
                        (if matching numPairsInit card1 card2 then
                            "Pair revealed!"

                         else
                            "It's not a pair, try again."
                        )
                    ]
                ]

            _ ->
                [ Html.span messageStyle [ Html.text "Click on cards to reveal them" ] ]
        )


cardView : List Card -> State -> Card -> Html Msg
cardView matched state card =
    if List.member card matched then
        cardRevealedView card

    else
        case state of
            OneRevealed card1 ->
                if card == card1 then
                    cardRevealedView card

                else
                    cardHiddenView matched state card

            TwoRevealed card1 card2 ->
                if List.member card [ card1, card2 ] then
                    cardRevealedView card

                else
                    cardHiddenView matched state card

            _ ->
                cardHiddenView matched state card


cardRevealedView : Card -> Html Msg
cardRevealedView card =
    Html.span cardStyle
        [ case card of
            Card emoji _ ->
                emojiToString emoji
                    |> Html.text
        ]


cardHiddenView : List Card -> State -> Card -> Html Msg
cardHiddenView matched state card =
    let
        isDisabled =
            List.member card matched
                || (case state of
                        TwoRevealed _ _ ->
                            True

                        _ ->
                            False
                   )
    in
    Html.button
        (onClick (Click card)
            :: disabled isDisabled
            :: cardStyle
        )
        [ Html.text "❓" ]


grid : Int -> Int -> List (Html.Attribute Msg)
grid rows columns =
    [ style "display" "grid"
    , style "grid-template-columns" (String.join " " (List.repeat columns "60pt"))
    , style "grid-template-rows" (String.join " " (List.repeat rows "60pt"))
    ]


cardStyle : List (Html.Attribute Msg)
cardStyle =
    [ style "font-size" "40pt"
    , style "margin" "5px"
    , style "padding" "2px"
    , style "border-radius" "1px"
    ]


messageStyle : List (Html.Attribute Msg)
messageStyle =
    [ style "font-size" "20pt"
    , style "margin" "5px"
    , style "padding" "2px"
    ]



-- HANDLING EMOJIS


type Emoji
    = Emoji Int


emojiToString : Emoji -> String
emojiToString (Emoji code) =
    code
        |> Char.fromCode
        |> String.fromChar


emojisList : List Emoji
emojisList =
    List.map Emoji
        [ 0x0001F400
        , 0x0001F403
        , 0x0001F404
        , 0x0001F405
        , 0x0001F406
        , 0x0001F407
        , 0x0001F408
        , 0x0001F409
        , 0x0001F40A
        ]



-- Inspired by https://github.com/O-O-Balance/pairs/
