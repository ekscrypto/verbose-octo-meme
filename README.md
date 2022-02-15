![iOS workflow](https://github.com/ekscrypto/verbose-octo-meme/actions/workflows/ios.yml/badge.svg) [![codecov](https://codecov.io/gh/ekscrypto/verbose-octo-meme/branch/main/graph/badge.svg?token=W9KO1BG8S0)](https://codecov.io/gh/ekscrypto/verbose-octo-meme) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) ![Issues](https://img.shields.io/github/issues/ekscrypto/verbose-octo-meme) ![Releases](https://img.shields.io/github/v/release/ekscrypto/verbose-octo-meme)

# verbose-octo-meme
Technical Interview Project



# Requirements
Text parsing:
* One screen; with edit field for input string and “Parse” button
* App contains dictionary of words
* When user presses “Parse” application will segment the input string into a space-
separated sequence of dictionary words if possible. Result will be displayed on the same
screen.
* For example, if the input string is "applepieshoe" and dictionary contains a standard set
of English words, then app would display the strings "apple”, “pie" and “shoe” as
output.
* The app should display all the words found in input string, for example if the input string
is “secondary” the app should display the strings “second” and “secondary”



# Overview of files
* VerboseOctoMemeApp.swift: Entry point of the SwiftUI app
* Injector.swift: Performs dependency-injection for production level code

* FormView.swift: Contains the input field & parse buttons for the user data entry
* ParserView.swift: Root screen of the app, includes the user entry form and output results
* ParserViewModel.swift: Implement the logic of when to begin parsing
* ResultsView.swift: Displays the results of the parsing

* EnglishWords.json: List of English words to parse against
* DictionaryDecoder.swift: Decode the JSON file that contains the english words
* DictionaryEntry.swift: Custom data types wrapper for String, that implements custom validation rules
* DictionaryWordsParser.swift: All the logic for how to parse the string against the English words



# Design decisions

## Dictionary size
Assuming the English language contains over 470,000 words
(ref: https://en.wikipedia.org/wiki/List_of_dictionaries_by_number_of_words)
loading the dictionary could take some time. We want the app to load up fast
so loading the dictionary will require to be on a background thread.

This also implies that the user should be made aware when the app is ready to
actually work properly (aka: dictionary fully loaded) so as to not get
unexpected results.

## SwiftUI
While I'm quite familiar with UIKit, I had little to none commercial experience using SwiftUI
so I took the liberty of doing this app using it to improve my skills.

You can refer to the iOS App "Piti Piti Pa" on the App Store if you want a demo of a fully
UIKit application I wrote by myself.  https://apps.apple.com/us/app/piti-piti-pa-djembe-studio/id757241907

## Data Validation
The longest English word is 45 letters long according to https://www.grammarly.com/blog/14-of-the-longest-words-in-english/

I thus created the DictionaryEntry custom Codable class to demonstrate how to securely decode
custom data types.  I also wrote a technical article on the subject at:
https://medium.com/swift2go/secure-json-handling-in-swift-9362d20773f3?sk=467694698c404137ec89e72d5ee42da3

Obviously in a production environment other languages would also have to be taken into consideration
to confirm the rules are relaxed to permit all expected words.

## Swift type declarations
Throughout the code base variable declarations include the data type specifier.  This was done purposefully
to reduce the total compile time of the project by saving Swift to do type inference.

If this is not part of the Swift Coding Guidelines of your team, I have no problem adjusting accordingly :)

## Project Files Grouping
There are various models used by developers to group files.  Some prefer to create root groups/folders for
"Models" and another one for "Views", etc.  This project was laid out to group closely related parts for
ease of navigation. Given the project size this seemed acceptable.

Again no problem following any project guidelines or discuss with the team as needed!

## Asynchronous Loading / Parsing
Again giving the consideration that you may want to parse against the entire English dictionary, this will
not be instantaneous and therefore Thread were dispatched.

In a production environment the Thread may further be optimized to run with a different priority level.

## Aborting an ongoing search
The code will cancel the thread running the search but the search itself will not currently be aborted, only
the results will never be dispatched.  This could easily be fixed by using a for loop on the dictionary
entries and looking for the Thread.current.isCancelled either at each loop or every few loops.  The current
code will hopefully be enough to properly evaluate my skills.

## Styling
The app should work by default in Dark & Light modes, but other than that no effort was made to use a custom
color scheme.  I would typically use a Style class defining various font sizes, colors, corner radius, etc and
then refer to this Style class in the various views.

Colors and Images can be implemented via an Asset catalog.

## Localization
Localization was outside of the requested scope.  If required it would be implemented via a Localizable.strings
and potentially a LocalizableDict for defining plural and other string variations.  If going that route I would
also advise using a parser to generate an enum of all strings.  A tool like SwiftGen should do fine.

## Enforced Code Styling
In production level app I would advise to use a syntax validation tool.  SwiftLint or something similar would
be appropriate.  You want to enforce simple stuff like where to put braces, spacing, etc.  It was left outside
the scope of this project to avoid using CocoaPods or requiring to download additional tools just to validate I
know how to write a .swiftgen.yml file.



# Manual Testing

## Simulating loading a very large dictionary
You can simulate loading a very large dictionary by uncommenting the for loop in DictionaryDecoder.swift

## Simulating parsing with very large dictionary
To simulate parsing against a very large dictionary, you can uncomment the for loop in DictionaryWordsParser.swift

## Portrait / Landscape
While the app was purposefully left to work in both Portrait and Landscape mode, no effort was made to make it
more useable in Landscape.  In a production environment either sufficient time would be given or coordination
with a UI/UX team would be required to properly implement landscape support.  If landscape support is not desirable
at all it can be disabled via the Info.plist keys



# Unit Tests

## Targets
The unit test target was purposefully not hosted in the primary target for the app.  This is to reduce the amount
of recompilation required when doing TDD.  In a very large project the unit tests could further be split into
multiple targets, probably one per vertical team, so as to keep developers as productive as possible.

As with everything else, if there are practices defined by the team that differs from the practices demonstrated
in this project (as I would expect), then it's a simple matter of reviewing & applying them.



# Licensing
The code in this repository is available under MIT license except the App Icon files.

App icon provided under limited distribution by Encoded Life Inc - DO NOT USE IN YOUR OWN PROJECTS
