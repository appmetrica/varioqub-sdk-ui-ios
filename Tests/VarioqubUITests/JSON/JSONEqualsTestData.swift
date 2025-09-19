
@testable import VarioqubUI

struct JSONEqualsTestData: CustomStringConvertible {
    
    var title: String
    var left: JSON
    var right: JSON
    var isEqual: Bool
    
    var description: String {
        title
    }
    
}

extension JSONEqualsTestData {
    
    static let testCase1: JSONEqualsTestData = .init(
        title: "testCase1",
        left: .bool(true),
        right: .bool(true),
        isEqual: true
    )
    
    static let testCase2: JSONEqualsTestData = .init(
        title: "testCase2",
        left: .integer(2),
        right: .integer(2),
        isEqual: true
    )
    
    static let testCase3: JSONEqualsTestData = .init(
        title: "testCase3",
        left: .double(5.678),
        right: .double(5.678),
        isEqual: true
    )
    
    static let testCase4: JSONEqualsTestData = .init(
        title: "testCase4",
        left: .array([.bool(true), .string("test"), .integer(123)]),
        right: .array([.bool(true), .string("test"), .integer(123)]),
        isEqual: true
    )
    
    static let testCase5: JSONEqualsTestData = .init(
        title: "testCase5",
        left: .array([.bool(true), .string("test"), .integer(123)]),
        right: .array([.string("test"), .integer(123), .bool(true)]),
        isEqual: false
    )
    
    static let testCase6: JSONEqualsTestData = .init(
        title: "testCase6",
        left: .object([
            "a": .integer(123),
            "b": .bool(true),
            "c": .string("text"),
        ]),
        right: .object([
            "a": .integer(123),
            "b": .bool(true),
            "c": .string("text"),
        ]),
        isEqual: true
    )
    
    static var testCase7: JSONEqualsTestData {
        var left: [String: JSON] = [:]
        var right: [String: JSON] = [:]
        
        left["a"] = .integer(123)
        left["b"] = .bool(true)
        left["c"] = .string("text")
        left["d"] = .double(123.4)
        
        right["d"] = .double(123.4)
        right["a"] = .integer(123)
        right["c"] = .string("t" + "e" + "x" + "t")
        right["b"] = .bool(true)
        
        
        return JSONEqualsTestData(
            title: "testCase7",
            left: .object(left),
            right: .object(right),
            isEqual: true
        )
    }
}

