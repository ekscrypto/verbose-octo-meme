//
//  DictionaryDecoder.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: Decode the JSON file that contains the english words

import Foundation

class DictionaryDecoder {

    enum Errors: Error {
        case dictionaryNotFound
    }

    func load(_ filename: String) throws -> [DictionaryEntry] {
        guard let fileUrl: URL = Bundle(for: DictionaryDecoder.self).url(forResource: filename, withExtension: "json") else {
            throw Errors.dictionaryNotFound
        }
        let dictionaryData: Data = try Data(contentsOf: fileUrl)
        let words: [DictionaryEntry] = try JSONDecoder().decode([DictionaryEntry].self, from: dictionaryData)
        
        // Add a 10-second delay simulating a very large dictionary being loaded
//        for _ in 0...10 {
//            Thread.sleep(forTimeInterval: 1.0)
//        }
        
        return words
    }
}
