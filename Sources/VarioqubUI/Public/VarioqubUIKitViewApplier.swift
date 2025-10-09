
import Foundation
import UIKit
import DivKit
import VGSLFundamentals

@MainActor
open class VarioqubUIKitViewApplier: VarioqubWidgetApplicable {
    
    public let parentView: UIView
    public let divComponents: DivKitComponents
    public let cardId: DivCardID
    private var divView: DivView?
    
    open var isDebugInfoEnabled: Bool = false
    
    public init(
        parentView: UIView,
        divComponents: DivKitComponents = DivKitComponents(),
        cardId: DivCardID = "popup_wrapper",
        isDebugInfoEnabled: Bool = false
    ) {
        self.parentView = parentView
        self.divComponents = divComponents
        self.cardId = cardId
        self.isDebugInfoEnabled = isDebugInfoEnabled
    }
    
    open func setSource(
        _ data: Data,
        params: VarioqubUIParams
    ) async {
        var variables = DivVariables()
        variables["params"] = .dict(params.divKitDictionary)
        divComponents.variablesStorage.append(variables: variables, triggerUpdate: false)
        
        let view = await createDivViewIfNeeded()
        await view.setSource(
            DivViewSource(kind: .data(data), cardId: cardId),
            debugParams: DebugParams(isDebugInfoEnabled: isDebugInfoEnabled)
        )
    }
    
    private func createDivViewIfNeeded() async -> DivView {
        if let divView = divView {
            return divView
        } else {
            let divView = await createDivView()
            self.divView = divView
            return divView
        }
    }
    
    private func createDivView() async -> DivView {
        let divView = DivView(divKitComponents: divComponents)
        setupInternalView(divView, parentView: parentView)
        return divView
    }
    
    open func setupInternalView(_ view: DivView, parentView: UIView) {
        parentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
    
}
