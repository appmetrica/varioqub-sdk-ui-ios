
@testable import VarioqubUI

struct JSONMergeTestData: CustomStringConvertible {
    
    var title: String
    var origin: JSON
    var overriden: JSON
    var expected: JSON
    
    var description: String { title }
}

extension JSONMergeTestData {
    
    static let testCase1 = JSONMergeTestData(
        title: "testCase1",
        origin: .integer(1),
        overriden: .string("2"),
        expected: .string("2")
    )
    
    static let testCase2 = JSONMergeTestData(
        title: "testCase2",
        origin: .object([
            "a": .integer(1),
            "b": .bool(true),
            "c": .string("c"),
        ]),
        overriden: .object([
            "a": .integer(2),
            "d": .double(345),
        ]),
        expected: .object([
            "a": .integer(2),
            "b": .bool(true),
            "c": .string("c"),
            "d": .double(345),
        ])
    )
    
    static let testCase3 = JSONMergeTestData(
        title: "testCase3",
        origin: .object([
            "a": .array([.integer(1), .integer(2), .integer(3)]),
        ]),
        overriden: .object([
            "a": .array([.integer(9), .integer(8), .integer(7)]),
        ]),
        expected: .object([
            "a": .array([.integer(9), .integer(8), .integer(7)]),
        ])
    )
    
    static let testCase4 = JSONMergeTestData(
        title: "testCase4",
        origin: .object([
            "a": .object([
                "a": .integer(1),
                "b": .string("c"),
            ]),
        ]),
        overriden: .object([
            "a": .object([
                "a": .integer(2),
                "d": .string("d"),
            ]),
        ]),
        expected: .object([
            "a": .object([
                "a": .integer(2),
                "b": .string("c"),
                "d": .string("d"),
            ]),
        ])
    )
    
}
