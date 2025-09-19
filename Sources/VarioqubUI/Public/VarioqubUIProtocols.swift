
import Foundation
import Varioqub

public protocol VarioqubUISync {
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams?
    ) throws
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) throws
    
}

public protocol VarioqubUIAsync {
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams?
    ) async throws
    
    func applyWidget(
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) async throws
    
}

public typealias VarioqubUIProviding = VarioqubUISync & VarioqubUIAsync
