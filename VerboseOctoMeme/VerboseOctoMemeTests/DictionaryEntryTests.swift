//
//  DictionaryEntryTests.swift
//  VerboseOctoMemeTests
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//

import XCTest

class DictionaryEntryTests: XCTestCase {

    func testZeroLength_invalid() {
        XCTAssertNil(DictionaryEntry(rawValue: ""), "Empty strings should not be valid dictionary entries")
    }
    
    func testOneLowercaseLetter_valid() {
        let lowercaseLetters: String = "abcdefghijklmnopqrstuvwxyzёèéēėę"
        for letter in lowercaseLetters {
            let oneLetterString: String = String(letter)
            XCTAssertEqual(DictionaryEntry(rawValue: oneLetterString)?.rawValue, oneLetterString, "Lowercase letter \(oneLetterString) expected to be a valid entry")
        }
    }

    func testOneUppercaseLetter_invalid() {
        let uppercaseLetters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZÈÉÊËĒĖĘ"
        for letter in uppercaseLetters {
            let oneLetterString:String = String(letter)
            XCTAssertNil(DictionaryEntry(rawValue: oneLetterString), "Uppercase letter \(oneLetterString) not allowed in dictionary entries. Only lowercase allowed")
        }
    }
    
    func testHello_valid() {
        XCTAssertEqual(DictionaryEntry(rawValue: "hello")?.rawValue, "hello", "Expected hello to be a valid dictionary entry.  It's all lowercases, non-empty and well under maximum length allowed")
    }
    
    func testDigitsAndSymbols_invalid() {
        let digitsAndSymbols: String = "1234567890-=_+/\\!!@#$%^&*()"
        for digitOrSymbol in digitsAndSymbols {
            let testString = String(digitOrSymbol)
            XCTAssertNil(DictionaryEntry(rawValue: testString), "Only lowercase letters should be allowed")
        }
    }
    
    func testLongestEnglishWord_valid() {
        XCTAssertEqual(DictionaryEntry(rawValue: "pneumonoultramicroscopicsilicovolcanoconiosis")?.rawValue, "pneumonoultramicroscopicsilicovolcanoconiosis", "Only-lowercase, non-empty and exactly 45 letters long should be allowed")
    }
    
    func testStateOfTheArt_valid() {
        XCTAssertNotNil(DictionaryEntry(rawValue: "state-of-the-art"), "Hyphenated words should be valid provided they are all lowercases")
    }
    
    func testTooManyHyphens_invalid() {
        XCTAssertNil(DictionaryEntry(rawValue: "s-t-a-t-e-of-the-a-r-t"), "I assumed that no english word should ever contain more than 4 hyphens")
    }
    
    func testLeadingHyphen_invalid() {
        XCTAssertNil(DictionaryEntry(rawValue: "-fast"), "No english word should start with an hyphen")
    }
    
    func testTrailingHyphen_invalid() {
        XCTAssertNil(DictionaryEntry(rawValue: "three-"), "While \"three- to four-week length\", is gramatically correct, the English word is three not three-")
    }
    
    func testTwoSuccessiveHyphens_invalid() {
        XCTAssertNil(DictionaryEntry(rawValue: "too--many"), "Successive hyphens should not be allowed")
    }
    
    func testAboveAllowedLength_invalid() {
        let maximumLengthString: String = String(repeating: "a", count: DictionaryEntry.maximumLength)
        let tooLongString: String = "\(maximumLengthString)a"
        XCTAssertNotNil(DictionaryEntry(rawValue: maximumLengthString), "A dictionary entry may contain up to maximum \(DictionaryEntry.maximumLength) characters")
        XCTAssertNil(DictionaryEntry(rawValue: tooLongString), "Expected \(tooLongString) to contain too many characters, maximum is \(DictionaryEntry.maximumLength)")
    }
    
    func testEncodable_matchRawValue() throws {
        let dictionaryEntry: DictionaryEntry = DictionaryEntry(rawValue: "motorcycle")!
        let encodedJson: Data = try JSONEncoder().encode(dictionaryEntry)
        let encodedAsString: String? = String(data: encodedJson, encoding: .ascii)
        XCTAssertEqual(encodedAsString, #""motorcycle""#, "The JSON value of the string should be the same string wrapped in double quotes")
    }
    
    func testEncodableArray_matchRawValues() throws {
        let firstValue: DictionaryEntry = DictionaryEntry(rawValue: "hello")!
        let secondValue: DictionaryEntry = DictionaryEntry(rawValue: "world")!
        let testValues: [DictionaryEntry] = [firstValue, secondValue]
        let encodedJson: Data = try JSONEncoder().encode(testValues)
        let encodedAsString: String? = String(data: encodedJson, encoding: .ascii)
        XCTAssertEqual(encodedAsString, #"["hello","world"]"#, "Expected RawRepresentable strings to be encoded same without modification, as an array of String")
    }
    
    func testDecodable_matchJson() throws {
        let encodedAsString: String = #"["hello","world"]"#
        let encodedJson: Data = encodedAsString.data(using: .ascii)!
        let testValues: [DictionaryEntry] = try JSONDecoder().decode([DictionaryEntry].self, from: encodedJson)
        XCTAssertEqual(testValues.count, 2, "Only two items were in the JSON array, so exactly two items should be in the output")
        XCTAssertEqual(testValues.first?.rawValue, "hello", "First String value in JSON array should be: hello")
        XCTAssertEqual(testValues.last?.rawValue, "world", "Second and last String value in JSON array should be: world")
    }
    
    func testDecodableInvalidCharacters_throws() {
        let encodedAsString: String = #"["hell!","world"]"#
        let encodedJson: Data = encodedAsString.data(using: .ascii)!
        XCTAssertThrowsError(try JSONDecoder().decode([DictionaryEntry].self, from: encodedJson), "Decoding should throw if any value is invalid")
    }
}
