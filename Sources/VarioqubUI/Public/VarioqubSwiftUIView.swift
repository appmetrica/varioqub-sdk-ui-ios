
import Foundation
import DivKit
import SwiftUI
import VGSLFundamentals

public struct VarioqubSwiftUIView: View {
    
    @ObservedObject private var viewModel: ViewModel
    private var isDebugInfoEnabled: Bool
    
    public init(viewModel: ViewModel, isDebugInfoEnabled: Bool = false) {
        self.viewModel = viewModel
        self.isDebugInfoEnabled = isDebugInfoEnabled
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if let data = viewModel.data {
            DivHostingView(
                divkitComponents: viewModel.divComponents,
                source: DivViewSource(kind: .data(data), cardId: viewModel.cardId),
                debugParams: DebugParams(isDebugInfoEnabled: isDebugInfoEnabled)
            )
        } else {
            EmptyView()
        }
    }
    public var body: some View {
        return contentView()
    }
}
extension VarioqubSwiftUIView {
    
    @MainActor
    open class ViewModel: ObservableObject, VarioqubWidgetApplicable {
        public let divComponents: DivKitComponents
        public let cardId: DivCardID
        
        public private(set) var data: Data?
        
        public init(
            divComponents: DivKitComponents = DivKitComponents(),
            cardId: DivCardID = "popup_wrapper"
        ) {
            self.divComponents = divComponents
            self.cardId = cardId
        }
        
        open func setSource(
            _ data: Data,
            params: VarioqubUIParams
        ) async {
            objectWillChange.send()
            
            self.data = data
            
            var variables = DivVariables()
            variables["params"] = .dict(params.divKitDictionary)
            divComponents.variablesStorage.append(variables: variables, triggerUpdate: true)
        }
        
    }
    
}
