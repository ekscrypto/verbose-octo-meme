//
//  Injector.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: Performs dependency-injection for production level code


import Foundation
import SwiftUI

class Injector {
    
    static func constructRootView() -> some View {
        defaultParserView()
    }

    static func defaultParserView() -> ParserView<DictionaryWordsParser> {
        let parser: DictionaryWordsParser = DictionaryWordsParser {
            if let loadedDictionary = try? DictionaryDecoder().load("EnglishWords") {
                return loadedDictionary
            }
            return []
        }
        
        let viewModel: ParserViewModel<DictionaryWordsParser> = ParserViewModel<DictionaryWordsParser>(parser: parser)
        return ParserView(initialInputText: "", viewModel: viewModel)
    }
}
