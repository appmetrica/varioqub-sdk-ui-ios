import Testing
import Foundation
@testable import VarioqubUI

@Suite("JSON Tests")
struct JSONTest {

    @Test func testBoolValue() {
        let value = JSON.bool(true)
        #expect(value.boolValue == true)
    }
    
    @Test func testIntValue() {
        let value = JSON.integer(1)
        #expect(value.intValue == 1)
    }
    
    @Test func testDoubleValue() {
        let value = JSON.double(1.0)
        #expect(value.doubleValue == 1.0)
    }
    
    @Test func testStringValue() {
        let value = JSON.string("test")
        #expect(value.stringValue == "test")
    }
    
    @Test func testArrayValue() {
        let value = JSON.array([JSON.bool(true), JSON.integer(1)])
        #expect(value.arrayValue == [JSON.bool(true), JSON.integer(1)])
    }
    
    @Test func testObjectValue() {
        let value = JSON.object(["test": JSON.bool(true)])
        #expect(value.dictionaryValue == ["test": JSON.bool(true)])
    }
    
    @Test("Decoding test", arguments: [
        JSONEncodingTestData.testData1,
        JSONEncodingTestData.testData2,
    ])
    func jsonDecodingTest(_ data: JSONEncodingTestData) throws {
        let jsonDecoder = JSONDecoder()
        let result = try jsonDecoder.decode(JSON.self, from: data.jsonData)
        #expect(result == data.expectedResult)
    }
    
    @Test("Equals test", arguments: [
        JSONEqualsTestData.testCase1,
        JSONEqualsTestData.testCase2,
        JSONEqualsTestData.testCase3,
        JSONEqualsTestData.testCase4,
        JSONEqualsTestData.testCase5,
        JSONEqualsTestData.testCase6,
        JSONEqualsTestData.testCase7,
    ])
    func jsonEqualsTest(_ data: JSONEqualsTestData) throws {
        if data.isEqual {
            #expect(data.left == data.right)
        } else {
            #expect(data.left != data.right)
        }
    }

    @Test("Merge Test", arguments: [
        JSONMergeTestData.testCase1,
        JSONMergeTestData.testCase2,
        JSONMergeTestData.testCase3,
        JSONMergeTestData.testCase4,
    ])
    func jsonMergeTest(_ data: JSONMergeTestData) {
        var result = data.origin
        result.merge(with: data.overriden)
        #expect(result == data.expected)
    }
    
}
