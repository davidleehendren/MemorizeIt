//
//  WordScrollView.swift
//  MemorizeIt
//
//  Created by David Hendren on 3/24/20.
//  Copyright © 2020 David Hendren. All rights reserved.
//

import SwiftUI

struct WordScrollView: View {
    var memorizeText: String
    //copy-paste from ContentView
    @State var parsedText = "[click button]"
    @State var spaceSplit: [Substring] = [""]
    @State var pctOfLetters = 50.0
    @State var blankChar: Character = Character("-")
    @State var wordCycle = ""
    @State var wordInc = 0
    
    var body: some View {
        NavigationView{
            VStack {
                Button("Cycle through words"){
                    self.spaceSplit = self.splitOnSpaces(self.memorizeText)
                    self.wordCycle = String(self.spaceSplit[self.wordInc])
                    if self.wordInc < self.spaceSplit.count-1 {
                        self.wordInc += 1
                    } else {self.wordInc = 0}
                }
                .buttons() //apply button style
                Spacer()
                Text(wordCycle)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.purple)
                    
                Spacer()
                NavigationLink(destination: ContentView()){
                    Text("Go back!")
                }
            }
            .navigationBarTitle("Word Quiz")
        }
    }
    
    //Functions start here*******************************
    
    //Step 1. takes a Word and returns that word with blanks except first letter
    func wordFirstLetterOnly (_ textToParse: String) -> String {
        let editStringArray = Array(textToParse)
        var firstLetterOnlyString = ""
        //add first letter so we don't blank it out
        firstLetterOnlyString += String(editStringArray[0])
        //deal with single-letter words
        if editStringArray.count == 1 {return firstLetterOnlyString}
        //blank out each additional character in the word
        for _ in editStringArray[1...editStringArray.count-1] {
            firstLetterOnlyString += String(blankChar)
        }
        return firstLetterOnlyString
    }
    
    //Step 2. takes a String and splits it into an array of substrings on " " character
    func splitOnSpaces(_ textToSplit: String) -> [Substring]  {
        //var spaceChar: Character = " "
        return textToSplit.split(separator: Character(" "))
    }
    
    //Step 3. combines splitOnSpaces and firstLetterOnly functions to fully parse text
    func firstLetterOnly(_ textToParse: String) -> String {
        var parsedText: String = ""
        for word in splitOnSpaces(textToParse) {
            parsedText += wordFirstLetterOnly(String(word)) + " "
        }
        return parsedText
    }
    
    func removeRandomLetters(pctOfLetters: Double, textToParse: String) -> String{
        var n = 0
        var parsedText = textToParse
        var blanksAdded = textToParse.filter {$0 == blankChar}.count
        let letterCount = (Double(textToParse.count)*pctOfLetters/100.0).rounded()
        
        //this is crude error catching - need to just replace with a tryCatch. For some reason the code hangs if the slider goes to 95+.
        if letterCount == 0.0  {return textToParse}else if Int(letterCount) == textToParse.count {return " "}
        //loop through the text by index, replacing the character with blankChar.
        repeat{
            n = Int.random(in: 0...parsedText.count-1) // loop from 0 to end of text
            //not totally sure what this outer if loop does (found online).
            if let index = parsedText.index(parsedText.startIndex, offsetBy: n, limitedBy: parsedText.endIndex) {
                if Array(textToParse)[n] == Character(" ") {continue} //don't remove spaces in text
                parsedText.remove(at: index)
                parsedText.insert(blankChar, at: index)
                blanksAdded = parsedText.filter {$0 == blankChar}.count
            } else {
                return "Error"
            }
        }while blanksAdded < Int(letterCount)
        return parsedText
    }
    
    func blankRandomWords(_ textToParse: String, _ pctOfWords: Double) -> String {
        print(textToParse)
        //make array to loop through words
        var textToParseArray = splitOnSpaces(textToParse)
        
        //final return value
        var parsedString = ""
        //how many words to blank out based on % input and words in string provided
        let wordsToBlank = Int((Double(textToParseArray.count)*pctOfWords/100.0).rounded())
        //how many words currently blanked
        var blankedWords = 0
        print("\(wordsToBlank) out of \(textToParseArray.count) words to blank out.") //test only
        
        //loop through this function until blankedWords = wordsToBlank
        repeat {
            //placeholder string for "David" -> "-----"
            var wordBlanked = ""
            //random word in array to try to blank out
            let removalIndex = Int.random(in: 0..<textToParseArray.count)
            //print("\(textToParseArray[removalIndex]) needs to be removed")
            //if word is already blank, skip and get a new random word
            if String((textToParseArray[removalIndex]).filter {$0 == blankChar}).count == String((textToParseArray[removalIndex])).count { //word is already blanked, continue
                continue
            }
                //if word isn't blank, blank it out
            else {
                //for each character in string at random index in array, create a "-" char in new string. *Need to replace "-" with blankChar in app!
                for _ in textToParseArray[removalIndex] {
                    wordBlanked += String(blankChar)
                }
                //replace original value in array with new, blanked value of same length.
                textToParseArray[removalIndex] = Substring(wordBlanked) //replace old value with blanks string in array
                //print("\(textToParseArray[removalIndex]) removed")
                //increment counter for loop
                blankedWords += 1
            }
        }while blankedWords < wordsToBlank
        
        //add all array elements (with blanked words) back to a return string, including spaces between elements in array.
        for i in 0...textToParseArray.count-1 {
            parsedString += textToParseArray[i] + " "
        }
        return parsedString
    }
    
}

struct WordScrollView_Previews: PreviewProvider {
    static var previews: some View {
        WordScrollView(memorizeText: "Memorize default string")
    }
}
