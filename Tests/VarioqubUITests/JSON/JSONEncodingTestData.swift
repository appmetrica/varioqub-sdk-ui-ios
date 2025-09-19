
import Foundation
@testable import VarioqubUI

struct JSONEncodingTestData: CustomStringConvertible {
    var title: String
    var jsonString: String
    var expectedResult: JSON
    
    var jsonData: Data {
        jsonString.data(using: .utf8) ?? Data()
    }
    
    var description: String {
        title
    }
}

extension JSONEncodingTestData {
    
    static let testData1 = JSONEncodingTestData(
        title: "testData1",
        jsonString: """
                    { 
                        "a": 1,
                        "b": true,
                        "c": "c",
                        "d": 123.4
                    }
            """,
        expectedResult: JSON.object([
            "a": JSON.integer(1),
            "b": JSON.bool(true),
            "c": JSON.string("c"),
            "d": JSON.double(123.4)
        ])
    )
    
    static let testData2 = JSONEncodingTestData(
        title: "testData2",
        jsonString: """
                    true
            """,
        expectedResult: JSON.bool(true)
    )
    
}
