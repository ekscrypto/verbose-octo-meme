//
//  DictionaryDecoderTests.swift
//  VerboseOctoMemeTests
//
//  Created by Dave Poirier on 2022-02-14.
//  Copyrights (c) Dave Poirier 2022.  Distributed under MIT License.
//

import XCTest

class DictionaryDecoderTests: XCTestCase {

    func testValidFile_expectsLoad() throws {
        let loadedDictionary: [DictionaryEntry] = try DictionaryDecoder().load("TestDictionary")
        XCTAssertEqual(loadedDictionary.count, 2)
    }
    
    func testUnknownFile_expectsThrows() {
        XCTAssertThrowsError(try DictionaryDecoder().load("This-file-does-not-exists"))
    }
}
