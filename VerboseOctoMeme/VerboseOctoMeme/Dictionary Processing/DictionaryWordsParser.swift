//
//  DictionaryWordsParser.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: All the logic for how to parse the string against the English words

import Foundation
import Combine

protocol ParserCompatible {
    func parse(_ value: String, result: @escaping (Set<DictionaryEntry>) -> Void) -> Thread
    var readyPublisher: Published<Bool>.Publisher { get }
}

class DictionaryWordsParser: ParserCompatible {
    
    @Published private(set) var ready: Bool = false
    var readyPublisher: Published<Bool>.Publisher { $ready }
    
    private var dictionary: [DictionaryEntry] = []
    private let dictionaryLock = NSLock()
    
    init(dictionary loadAction: @escaping () -> [DictionaryEntry] ) {
        loadDictionary(loadAction)
    }
    
    private func loadDictionary(_ loadAction: @escaping () -> [DictionaryEntry]) {
        Thread { [weak self] in
            let loadedDictionary = loadAction()
            self?.updateDictionary(loadedDictionary)
        }.start()
    }
    
    private func updateDictionary(_ loadedDictionary: [DictionaryEntry]) {
        dictionaryLock.lock()
        dictionary = loadedDictionary
        dictionaryLock.unlock()
        ready = true
    }
    
    func parse(_ parsedText: String, result: @escaping (Set<DictionaryEntry>) -> Void) -> Thread {
        dictionaryLock.lock()
        let dictionaryWords = dictionary
        dictionaryLock.unlock()

        let processingThread = Thread {
            let identifiedWords: Set<DictionaryEntry> = DictionaryWordsParser.findWords(parsedText, dictionary: dictionaryWords)
            if Thread.current.isCancelled {
                return
            }
            
            // Add a 2-second delay simulating identifying against a very large dictionary
//            for _ in 0...2 {
//                Thread.sleep(forTimeInterval: 1.0)
//            }
            
            result(identifiedWords)
        }
        processingThread.start()
        return processingThread
    }
    
    private static func findWords(_ inputText: String, dictionary: [DictionaryEntry]) -> Set<DictionaryEntry> {
        let lowercasedInput = inputText.lowercased()
        let identifiedEntries: [DictionaryEntry] = dictionary.filter { dictionaryEntry in
            lowercasedInput.contains(dictionaryEntry.rawValue)
        }
        return Set(identifiedEntries)
    }
}
