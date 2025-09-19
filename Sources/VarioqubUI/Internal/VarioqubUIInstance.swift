
import Foundation
import Varioqub

final class VarioqubUIInstance: VarioqubUISync, VarioqubUIAsync {
    
    let instance: VarioqubInstanceProviding
    let widgetProcessor = VarioqubUIWidgetProcessor.shared
    
    init(instance: VarioqubInstanceProviding) {
        self.instance = instance
    }
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: any VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams? = nil
    ) async throws {
        try await widgetProcessor.applyWidget(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
    }
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: any VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams? = nil
    ) throws {
        try widgetProcessor.applyWidget(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
    }
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: any VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) async throws {
        try await widgetProcessor.applyWidget(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            url: url,
            paramName: paramName,
            isEncrypted: isEncrypted
        )
    }
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: any VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) throws {
        try widgetProcessor.applyWidget(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            url: url,
            paramName: paramName,
            isEncrypted: isEncrypted
        )
    }
    
    

}
