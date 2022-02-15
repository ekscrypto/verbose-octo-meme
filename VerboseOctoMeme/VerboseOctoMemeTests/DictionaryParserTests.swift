//
//  DictionaryWordsParserTests.swift
//  VerboseOctoMemeTests
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//

import XCTest
import Combine

class DictionaryWordsParserTests: XCTestCase {
    
    let defaultTimeout: TimeInterval = 2.0
    
    func prepareParser(words: [String]) -> DictionaryWordsParser {
        let entries: [DictionaryEntry] = words.map { DictionaryEntry(rawValue: $0)! }
        let parser: DictionaryWordsParser = DictionaryWordsParser(dictionary: { entries })
        let parserReadyExpectation: XCTestExpectation = XCTestExpectation(description: "")
        let readyObserver: AnyCancellable = parser.readyPublisher.sink { ready in
            if ready {
                parserReadyExpectation.fulfill()
            }
        }
        wait(for: [parserReadyExpectation], timeout: defaultTimeout)
        _ = readyObserver
        return parser
    }

    func testSecondary_expectsSecondAndSecondary() {
        let parser: DictionaryWordsParser = prepareParser(words: ["second","secondary","should-not-match"])
        let parsingToCompleteExpectation: XCTestExpectation = XCTestExpectation(description: "Parser should return within a reasonable amount of time")
        let parsingThread: Thread = parser.parse("Secondary") { results in
            XCTAssertEqual(results.count, 2, "Exactly 2 matches are expected, Secondary and Second, Optional should not be matched")
            XCTAssertTrue(results.contains(where: { $0.rawValue == "secondary" }))
            XCTAssertTrue(results.contains(where: { $0.rawValue == "second"}))
            parsingToCompleteExpectation.fulfill()
        }
        wait(for: [parsingToCompleteExpectation], timeout: defaultTimeout)
        parsingThread.cancel()
    }

    func testApplepieshoe_expectsApplePieAndShoe() {
        let parser: DictionaryWordsParser = prepareParser(words: ["apple", "should-not-match", "pie", "shoe"])
        let parsingToCompleteExpectation: XCTestExpectation = XCTestExpectation(description: "Parser should return within a reasonable amount of time")
        let parsingThread: Thread = parser.parse("ApplePieShoe") { results in
            XCTAssertEqual(results.count, 3, "Apple, Pie and Shoe should be matched, Optional should not be matched")
            XCTAssertTrue(results.contains(where: { $0.rawValue == "apple" }))
            XCTAssertTrue(results.contains(where: { $0.rawValue == "pie" }))
            XCTAssertTrue(results.contains(where: { $0.rawValue == "shoe" }))
            parsingToCompleteExpectation.fulfill()
        }
        wait(for: [parsingToCompleteExpectation], timeout: defaultTimeout)
        parsingThread.cancel()
    }
    
    func testNoMatch_expectsEmptySet() {
        let parser: DictionaryWordsParser = prepareParser(words: ["apple","should-not-match","pie","shoe"])
        let parsingToCompleteExpectation: XCTestExpectation = XCTestExpectation(description: "Parser should return within a reasonable amount of time")
        let parsingThread: Thread = parser.parse("Maple Syrup") { results in
            XCTAssertEqual(results.count, 0, "None of the dictionary words are in the input string, so there should be no match")
            parsingToCompleteExpectation.fulfill()
        }
        wait(for: [parsingToCompleteExpectation], timeout: defaultTimeout)
        parsingThread.cancel()
    }
}
