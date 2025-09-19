
import Foundation
import Testing
import Varioqub
@testable import VarioqubUI

@Suite("VarioqubUIWidgetProcessor")
struct VarioqubUIWidgetProcessorTest {
    
    private let widgetProcessor = VarioqubUIWidgetProcessor()
    
    private let varioqubMock: VarioqubInstanceMock
    private let varioqubWidgetMock: VarioqubUIWidgetApplicableMock
    
    private let widgetName = VarioqubFlag(rawValue: "widgetName")
    private let widgetNameEmpty = VarioqubFlag(rawValue: "widgetNameEmpty")
    private let widgetValue: String = """
        {
            "resource_key": "resourceName",
            "params": {
                "param1": "value1",
                "param2": "value2"
            }
        }
        """
    private let widgetParams = VarioqubUIParams(_values: [
        "param1": .string("value1"),
        "param2": .string("value2")
    ])
    private let resourceName: VarioqubResourceKey = VarioqubResourceKey(rawValue: "resourceName")
    private let resourceValue: String = "resourceValue"
    
    init() {
        varioqubMock = VarioqubInstanceMock()
        varioqubMock.allItems = [
            widgetName: VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: widgetValue),
                triggeredTestID: nil
            ),
        ]
        varioqubMock.resources = [
            resourceName: VarioqubResource(type: "string", value: resourceValue),
        ]
        
        varioqubWidgetMock = VarioqubUIWidgetApplicableMock()
    }
    
    @Test
    func testApplyWidget() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            varioqubWidgetMock.setSourceHandler = { data, params in
                #expect(String(data: data, encoding: .utf8) == resourceValue)
                #expect(params == widgetParams)
                
                confirmation.confirm()
            }
            
            try await widgetProcessor.applyWidget(
                instance: varioqubMock,
                widgetName: widgetName,
                widgetApplier: varioqubWidgetMock,
                extraParams: nil
            )
        }
    }
    
    @Test
    func testApplyWidgetWithOverrideParams() async throws {
        let overrideParams: VarioqubUIParams = .init(_values: [
            "param1": .string("overrideValue1"),
            "param3": .string("overrideValue3"),
        ])
        let expectedParams: VarioqubUIParams = .init(_values: [
            "param1": .string("overrideValue1"),
            "param2": .string("value2"),
            "param3": .string("overrideValue3"),
        ])
        
        try await confirmation(expectedCount: 1) { confirmation in
            varioqubWidgetMock.setSourceHandler = { data, params in
                #expect(String(data: data, encoding: .utf8) == resourceValue)
                #expect(params == expectedParams)
                
                confirmation.confirm()
            }
            
            try await widgetProcessor.applyWidget(
                instance: varioqubMock,
                widgetName: widgetName,
                widgetApplier: varioqubWidgetMock,
                extraParams: overrideParams
            )
        }
    }
    
    @Test
    func testApplyWidgetWithURL() async throws {
        let jsonString = """
            {
                "param1": "overrideValue1",
                "param3": "overrideValue3"
            }
            """
        let jsonData = jsonString.data(using: .utf8)?.base64EncodedString() ?? ""
        let url = URL(string: "https://varioqub.io/url?param=\(jsonData)&isEncrypted=true")!
        
        let expectedParams: VarioqubUIParams = .init(_values: [
            "param1": .string("overrideValue1"),
            "param2": .string("value2"),
            "param3": .string("overrideValue3"),
        ])
        
        try await confirmation(expectedCount: 1) { confirmation in
            varioqubWidgetMock.setSourceHandler = { data, params in
                #expect(String(data: data, encoding: .utf8) == resourceValue)
                #expect(params == expectedParams)
                
                confirmation.confirm()
            }
            
            try await widgetProcessor.applyWidget(
                instance: varioqubMock,
                widgetName: widgetName,
                widgetApplier: varioqubWidgetMock,
                url: url,
                paramName: "param",
                isEncrypted: true
            )
        }
    }

    @Test
    func testApplyWidgetWithEmptyValue() async throws {
        await #expect(throws: VarioqubError.self) {
            try await widgetProcessor.applyWidget(
                instance: varioqubMock,
                widgetName: widgetNameEmpty,
                widgetApplier: varioqubWidgetMock,
                extraParams: nil
            )
        }
    }
    
    @Test
    func testApplyWidgetWithoutResource() async throws {
        varioqubMock.resources = [:]
        await #expect(throws: VarioqubError.self) {
            try await widgetProcessor.applyWidget(
                instance: varioqubMock,
                widgetName: widgetName,
                widgetApplier: varioqubWidgetMock,
                extraParams: nil
            )
        }
    }
    
}
