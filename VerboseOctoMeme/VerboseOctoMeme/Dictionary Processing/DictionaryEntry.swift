//
//  DictionaryEntry.swift
//  VerboseOctoMeme
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//
//  PURPOSE: Custom data types wrapper for String, that implements custom validation rules

import Foundation

struct DictionaryEntry: Codable, RawRepresentable, Hashable {
    let rawValue: String
    
    enum Errors: Error {
        case empty
        case tooLong
        case invalidCharacters
        case invalidHyphenation
    }
    
    static let maximumLength: Int = 45
    static let maximumHyphenations: Int = 4
    static let allowedCharacterSet: CharacterSet = .lowercaseLetters
    
    init?(rawValue: String) {
        guard let validatedValue = try? DictionaryEntry.validated(rawValue) else {
            return nil
        }
        self.rawValue = validatedValue
    }

    init(from decoder: Decoder) throws {
        let candidate = try decoder
            .singleValueContainer()
            .decode(String.self)
        self.rawValue = try DictionaryEntry.validated(candidate)
    }
    
    /// Validate that a String fulfills all the required criteria to be a valid DictionaryEntry
    /// - Parameter candidate: String to validate
    /// - Returns: identical String object if valid, error thrown otherwise
    static func validated(_ candidate: String) throws -> String {
        try lengthIsWithinRange(candidate)
        try containsOnlyValidCharactera(candidate)
        return candidate
    }

    private static func lengthIsWithinRange(_ candidate: String) throws -> Void {
        guard candidate.count <= maximumLength else {
            throw Errors.tooLong
        }
        guard !candidate.isEmpty else {
            throw Errors.empty
        }
    }
    
    private static func containsOnlyValidCharactera(_ candidate: String) throws -> Void {
                
        try doesNotStartOrEndWithHyphen(candidate)
        let hyphenatedWords = try hyphenatedWords(from: candidate)
        
        let disallowedCharacters = allowedCharacterSet.inverted
        guard hyphenatedWords.allSatisfy({ $0.rangeOfCharacter(from: disallowedCharacters) == nil }) else {
                throw Errors.invalidCharacters
        }
    }
    
    private static func doesNotStartOrEndWithHyphen(_ candidate: String) throws -> Void {
        // No english word should start or end with a hyphen
        guard !candidate.hasPrefix("-"),
              !candidate.hasSuffix("-")
        else {
            throw Errors.invalidHyphenation
        }
    }
    
    private static func hyphenatedWords(from candidate: String) throws -> [String] {
        let hyphenatedwords = candidate.components(separatedBy: "-")
        guard hyphenatedwords.count <= maximumHyphenations else {
            throw Errors.invalidHyphenation
        }
        guard hyphenatedwords.allSatisfy({ !$0.isEmpty }) else {
            throw Errors.invalidHyphenation
        }
        return hyphenatedwords
    }
}
