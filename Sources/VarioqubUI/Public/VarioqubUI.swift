
import Foundation
import Varioqub

public final class VarioqubUI: VarioqubUISync, VarioqubUIAsync {
    
    public static let shared = VarioqubUI()
    
    private lazy var facade = VarioqubFacade.shared
    private lazy var widgetProcessor = VarioqubUIWidgetProcessor.shared
    
    public func instance(clientId: String) -> VarioqubUIProviding {
        return VarioqubUIInstance(instance: facade.instance(clientId: clientId))
    }
    
    public var mainInstance: VarioqubUIProviding {
        return VarioqubUIInstance(instance: facade.mainInstance)
    }
    
    public func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams?
    ) throws {
        try widgetProcessor.applyWidget(
            instance: facade.mainInstance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
    }
    
    public func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) throws {
        try mainInstance.applyWidget(
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            url: url,
            paramName: paramName,
            isEncrypted: isEncrypted
        )
    }
    
    public func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams?
    ) async throws {
        try await mainInstance.applyWidget(
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
    }
    
    public func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) async throws {
        try await mainInstance.applyWidget(
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            url: url,
            paramName: paramName,
            isEncrypted: isEncrypted
        )
    }
    
}

