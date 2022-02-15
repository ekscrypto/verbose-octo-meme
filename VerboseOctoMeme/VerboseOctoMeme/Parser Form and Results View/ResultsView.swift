//
//  ResultsView.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: Displays the results of the parsing

import SwiftUI

struct ResultsView: View {
    
    let parsedText: String
    let identifiedWords: [DictionaryEntry]
    var joinedWords: String {
        identifiedWords
            .map({ $0.rawValue })
            .joined(separator: " ")
    }
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 20) {

            Divider()

            Text("Parsed text:")
            searchedTextSummary(parsedText)
            
            Text("Matches: \(identifiedWords.count)")
            listOfMatchedWords(identifiedWords)
            
            Text("Space separated list of matched dictionary words:")
            requestedSearchResult(joinedWords)
        }
        .padding()
    }
    
    private func searchedTextSummary(_ parsedText: String) -> some View {
        VStack(alignment: .center, spacing: 0) {
            GroupBox {
                Text(parsedText)
                    .lineLimit(3)
                    .accessibilityIdentifier("SearchedTextSummary")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    private func listOfMatchedWords(_ matchedWords: [DictionaryEntry]) -> some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(matchedWords, id: \.rawValue) { word in
                GroupBox {
                    Text(word.rawValue)
                }
            }
        }.frame(minWidth: 0, maxWidth: .infinity)
    }

    private func requestedSearchResult(_ requestedOutput: String) -> some View {
        VStack(alignment: .center, spacing: 0) {
            GroupBox {
                Text(requestedOutput)
                    .accessibilityIdentifier("RequestedResults")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultsView(
                parsedText: "I Love Hello World",
                identifiedWords: [
                    DictionaryEntry(rawValue: "Hello")!,
                    DictionaryEntry(rawValue: "World")!])
            
            ResultsView(
                parsedText: "Nothing to match",
                identifiedWords: [])
        }
    }
}
