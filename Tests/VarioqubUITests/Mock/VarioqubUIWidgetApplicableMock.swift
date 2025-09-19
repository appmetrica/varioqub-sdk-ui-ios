
import Foundation
@testable import VarioqubUI

final class VarioqubUIWidgetApplicableMock: VarioqubWidgetApplicable {
    
    typealias SourceHandler = (Data, VarioqubUIParams) -> Void
    var setSourceHandler: SourceHandler?
    
    func setSource(_ data: Data, params: VarioqubUIParams) async {
        setSourceHandler?(data, params)
    }
    
}
