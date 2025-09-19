
import Foundation

public protocol VarioqubWidgetApplicable {
    
    func setSource(
        _ data: Data,
        params: VarioqubUIParams
    ) async
    
}
