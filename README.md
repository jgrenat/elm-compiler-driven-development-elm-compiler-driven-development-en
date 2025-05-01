# Compiler Driven Development with Elm!


<img src="./resources/elm-logo.svg" alt="" role="presentation" width="150" height="150" />

_🇫🇷 Si vous cherchez une version française de ce workshop, [cliquez ici](https://github.com/jgrenat/elm-compiler-driven-development)._

Welcome to our workshop to discover the Elm language and a new programming paradigm: let the compiler tell you what to do!

But first, let's start by installing Elm:

## Installing Elm

There are two ways to install Elm. You can either [download and install it from this page (recommended) of the official guide](https://guide.elm-lang.org/install/elm.html), or use npm with the following command:

```bash
npm install --global elm
```

## Set Up Elm Plugin in your Editor

Now that Elm is installed, you can set up your text editor for syntax highlighting!

- [Atom](https://atom.io/packages/language-elm)
- [Emacs](https://github.com/jcollard/elm-mode)
- [Webstorm / IntelliJ](https://github.com/klazuka/intellij-elm)
- [Sublime Text](https://guide.elm-lang.org/install/editor.html)
- [Vim](https://github.com/ElmCast/elm-vim)
- [VS Code](https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode)

**Note :** This workshop is designed to work with the error messages as shown by the compiler. The messages displayed by the plugins listed above may not exactly match the compiler’s errors.
We therefore recommend "ignoring" the errors shown in your editor _for this workshop_ and instead focusing on those displayed in your browser.


## Get the workshop

You can now get the code for this workshop either by [downloading the archive](https://github.com/jgrenat/elm-compiler-driven-development/archive/master.zip), or by cloning it:

```bash
git clone https://github.com/jgrenat/elm-compiler-driven-development-en.git
cd elm-compiler-driven-development-en
```

Once you have the workshop files using one of the two methods above, run the following command at the root of the project:

```bash
elm reactor
```

The exercises files can be accessed at http://localhost:8000/src

## Workshop Flow

Each file represents an exercise. You can begin an exercise by opening it in Elm Reactor, for example at
http://localhost:8000/src/Exercise010String.elm for the first one. 

Don’t be surprised if an error appears — that’s normal! Read it carefully; the compiler is your mentor to help you fix it! 💪

Once the code compiles, the exercise is complete. Congrats! You can move on to the next one! 🎉

After finishing the first exercises, you can move to the next level in the `Advanced` folder.

You’ll follow the same path to develop new features in an existing application: write code that triggers a compilation error and let the compiler guide you. This is a very effective approach, no matter the size of your project.
This is what's called Compiler-Driven Development!

## Stuck?

No worry — we’re here to help! Wave your hand wildly and we’ll come to you! 🙋‍♀️🙋‍♂️


## Authors

This workshop was authored by [Sébastien Besnier](https://github.com/sebsheep) and [Jordane Grenat](https://github.com/jgrenat).
Feel free to use it for yourself or to teach others! Any feedback is welcome! 
