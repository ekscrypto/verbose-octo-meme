//
//  ParserViewModel.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: Implement the logic of when to begin parsing

import Foundation
import Combine

class ParserViewModel<Parser: ParserCompatible>: ObservableObject {
    @Published var identifiedWords: [DictionaryEntry] = []
    @Published var parsedText: String?
    @Published var parserReady: Bool = false
    @Published var parserBusy: Bool = false

    private var parser: Parser
    private var parsingThread: Thread?
    private var parserReadyCancellable: AnyCancellable?

    init(parser: Parser) {
        self.parser = parser
        observeParserReady()
        
    }
    
    func observeParserReady() {
        parserReadyCancellable = parser.readyPublisher
            .sink(receiveValue: { [weak self] ready in
                self?.parserReady = ready
        })
    }
    
    func parse(_ inputText: String) {
        guard parserReady else {
            return
        }
        parsingThread?.cancel()
        identifiedWords = []
        parsedText = nil
        parserBusy = true
        parsingThread = parser.parse(inputText, result: { [weak self] resultSet in
            let sortedResults = Array(resultSet).sorted(by: { $0.rawValue < $1.rawValue })
            DispatchQueue.main.async {
                self?.parsedText = inputText
                self?.identifiedWords = sortedResults
                self?.parserBusy = false
            }
        })
    }
}
