//
//  ContentView.swift
//  MemorizeIt
//
//  Created by David Hendren on 3/13/20.
//  Copyright © 2020 David Hendren. All rights reserved.
//

import SwiftUI

//ongoing issues, notes, to-do's:
//Theres some weird error where allowign the slider to go to 100 breaks the Remove Random Letters function. Doesnt' seem to hurt Remove Words though.
//I have hard coded paddings, widths, etc... Needs to be set based on % of maxWidth, height, etc...
//I need an OnStart function to set some parameters, I think. Then I wouldn't have to set parsedText = memorizeText in every function. Not a high priority though.
//The TextField view doesn't support multi-line entry, so your text leaves the screen if its longer than a couple sentences. I've gotten around this by duplicating it in the Text view directly below for now.

struct ContentView: View {
    //Variables
    @State var memorizeText = "Let the peace of Christ rule in your hearts, to which you were called in one body; and be thankful."
    @State var parsedText = "[click button]"
    @State var spaceSplit: [Substring] = [""]
    @State var pctOfLetters = 50.0
    @State var blankChar: Character = Character("-")
    @State var test = ""
    @State var wordInc = 0
    
    let maroon = Color(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)
    let gold = Color(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0)
    @State private var toggleText = true
    
    //Main View
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [maroon, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack {
                    Text("Enter your text below:")
                        .font(.headline)
                        .fontWeight(.bold)
                    TextField("Default text", text: $memorizeText) //,onCommit: {parsedText = memorizeText}
                        .lineLimit(nil) //this annoyingly does not work..
                        .foregroundColor(Color.white)
                    VStack{
                        Text("Full text to memorize:")
                            .foregroundColor(gold)
                        if toggleText {
                            Text(memorizeText)
                        }
                    }
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                }
                //.shadow(color: .black, radius: 2)
                //^ THIS BREAKS EVERYTHING!!!

                .padding(.top, 50.0)
                HStack{
                    Text("% of letters to remove: 0")
                        .lineLimit(1)
                    Slider(value: $pctOfLetters, in: 10...80, step: 1.0)
                        .frame(width: 150.0)
                    Text("80")
                }
                Text(String(pctOfLetters) + "% to remove.")

                //Buttons
                VStack{
                    HStack{
                        Button(action: {
                            self.parsedText = self.firstLetterOnly(self.memorizeText)
                        }) {
                            Text("Keep First Letters Only")
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                        
                        Button(action: {
                            self.parsedText = self.removeRandomLetters(pctOfLetters: self.pctOfLetters, textToParse: self.memorizeText)
                        }) {
                            Text("Remove Letters")
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                    }
                    .padding(.top, 30.0)
                    //.padding(.bottom, 30.0)
                    .foregroundColor(Color.blue)
                    
                    //second row of buttons
                    HStack{
                        Button(action: {
                            self.parsedText = self.blankRandomWords(self.memorizeText, self.pctOfLetters)
                        }) {
                            Text("Remove Words")
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                    }
                    //.padding(.top, 30.0)
                    .padding(.bottom, 30.0)
                    .foregroundColor(Color.blue)
                    
                }
                VStack{
                    //display parsed text
                    Text("Updated text below:")
                        .fontWeight(.bold)
                    Text(parsedText)
                    Text("******************")
                    Text("Test auto-display instead of button-driven:")
                        .fontWeight(.bold)
                        .padding(.top, 10.0)
                    Text(blankRandomWords(memorizeText, pctOfLetters))
                    //test a button that displays a word from the first string you can increment through.
                    Button("Cycle through words"){
                        self.spaceSplit = self.splitOnSpaces(self.memorizeText)
                        self.test = String(self.spaceSplit[self.wordInc])
                        if self.wordInc < self.spaceSplit.count-1 {
                          self.wordInc += 1
                        } else {self.wordInc = 0}
                    }
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                    .foregroundColor(Color.blue)

                    Text(test)
                    Spacer()
                    Toggle(isOn: $toggleText) {
                        Text("Hide original text")
                    
                    }
                }
            }
            .foregroundColor(gold)
            //.shadow(color: .black, radius: 2)
        }
        
    }
    
    
    
    
    //Functions start here
    
    //Step 1. takes a String and returns that string with blanks except first letter
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
    
    
    //***********Formatting functions**********
    func font(_ font: Font?) -> some View
    {
        foregroundColor(gold)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
