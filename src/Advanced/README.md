# Advanced Exercises

Already here? You were quick! Congratulations, you've completed the first part! 
Now it's time for you to dive into more complex applications.

This time, the code compiles, so you can run the app to understand its logic.

Then, you can start modifying the code by intentionally causing a compilation error, which will let the compiler guide you. 
This is a common strategy in Elm.

## Draw Me an Elm Tree

The first application is in the `Advanced/ExerciseDraw.elm` file. 
You can draw segments by clicking on two points in the frame (we'll be competing with Photoshop soon!).

### Undo the Last Action

Let's implement a button to undo the last line drawn!

You can add the following button and let the compiler guide you:

```elm
Html.button
    [ onClick Cancel
    , style "font-size" "20pt"
    , style "margin" "5px"
    ]
    [ Html.text "Undo" ]
```

### Replay the Last Action Undone

If the user has undone any lines, display an "Redo" button. When clicked, the last undone line is redrawn.

_Hint:_ You’ll probably need to add a list of undone lines in the `Model`...

**Warning**: If the user undoes a line and then draws another, the undone line is "lost" and can't be redone.


## Memory Game

The second application is in the `Advanced/ExerciseMemoryGame.elm` file. 
It’s a memory game where you have to find pairs of animals.

We ask you to implement two new features for this application, one that is fairly simple
and the other one that is much more complex.

### Play again

Once the game is over, we would like to be able to start a new game. 
We suggest adding the following button, which should only appear once the game is finished:

```elm
Html.button
    [ onClick Restart
    , style "font-size" "20pt"
    , style "margin" "5px"
    ]
    [ Html.text "Play again" ]
```

Now, you should have a compilation error... Let the compiler guide you 😉!

### Bomb!

We want to add a bomb below one of the cards: when the player clicks on it for the first time, the bomb is primed. 
If the player clicks on it a second time, the game is lost!

Here is the "bomb" emoji you can copy/paste: 💣 

We suggest modifying the `Card type like this:

```elm
type Card
    = Card Emoji Instance
    | Bomb -- Unprimed bomb
    | PrimedBomb -- Primed bomb
```

And once again, let the compiler guide you!