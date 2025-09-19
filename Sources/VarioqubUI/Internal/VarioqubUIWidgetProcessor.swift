import Foundation
import Varioqub

typealias VarioqubInstanceProviding = VarioqubResourcesProvider & VarioqubFlagProvider

final class VarioqubUIWidgetProcessor {
    
    static let shared = VarioqubUIWidgetProcessor()
    
    private lazy var jsonStructDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private lazy var jsonFreeformDecoder = JSONDecoder()
    
    init() {
    }
    
    func applyWidget(
        instance: VarioqubInstanceProviding,
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams?
    ) throws {
        let (jsonData, params) = try applyWidgetPreparation(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
        
        Task {
            await widgetApplier.setSource(
                jsonData,
                params: params
            )
        }
    }
    
    func applyWidget(
        instance: VarioqubInstanceProviding,
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) throws {
        let extraParams = try applyWidgetWithURLPreparation(url: url, paramName: paramName, isEncrypted: isEncrypted)
        try applyWidget(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
    }
    
    func applyWidget(
        instance: VarioqubInstanceProviding,
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams?
    ) async throws {
        let (jsonData, params) = try applyWidgetPreparation(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
        
        await widgetApplier.setSource(
            jsonData,
            params: params
        )
    }
    
    func applyWidget(
        instance: VarioqubInstanceProviding,
        widgetName: VarioqubFlag,
        widgetApplier: VarioqubWidgetApplicable,
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) async throws {
        let extraParams = try applyWidgetWithURLPreparation(url: url, paramName: paramName, isEncrypted: isEncrypted)
        try await applyWidget(
            instance: instance,
            widgetName: widgetName,
            widgetApplier: widgetApplier,
            extraParams: extraParams
        )
    }
    
}

private extension VarioqubUIWidgetProcessor {
    
    func applyWidgetPreparation(
        instance: VarioqubInstanceProviding,
        widgetName: VarioqubFlag,
        widgetApplier: any VarioqubWidgetApplicable,
        extraParams: VarioqubUIParams? = nil
    ) throws -> (Data, VarioqubUIParams) {
        let widgetString = instance.getString(for: widgetName, defaultValue: "")
        guard !widgetString.isEmpty, let widgetData = widgetString.data(using: .utf8) else {
            throw VarioqubError.invalidVarioqubValue(key: widgetName, underlyingError: nil)
        }
        
        let widgetInfo = try wrapInvalidVarioqubValue(key: widgetName) {
            try jsonStructDecoder.decode(VarioqubUIWidgetInfo.self, from: widgetData)
        }
        
        let resourceKey = VarioqubResourceKey(rawValue: widgetInfo.resourceKey)
        guard let resource = instance.resource(for: resourceKey) else {
            throw VarioqubError.resourceKeyNotFound(key: resourceKey)
        }
        
        var params = VarioqubUIParams(_values: widgetInfo.params ?? [:])
        if let extraParams = extraParams {
            params.merge(with: extraParams)
        }
        
        guard let jsonData = resource.value.data(using: .utf8) else {
            throw VarioqubError.conversionFailed
        }
        
        return (jsonData, params)
    }
    
    func applyWidgetWithURLPreparation(
        url: URL,
        paramName: String,
        isEncrypted: Bool
    ) throws -> VarioqubUIParams? {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let paramValue = urlComponents?.queryItems?.first { $0.name == paramName}?.value
        guard  let paramValue = paramValue else { return nil }
        
        let jsonString: String?
        if isEncrypted {
            let decoded = Data(base64Encoded: paramValue)
            jsonString = decoded.flatMap { String(data: $0, encoding: .utf8) }
        } else {
            jsonString = paramValue
        }
        let jsonData = jsonString?.data(using: .utf8)
        
        let json = try jsonData.flatMap { try jsonFreeformDecoder.decode(JSON.self, from: $0) }
        let overrideParams = json?.dictionaryValue.map { VarioqubUIParams(_values: $0) }
        
        return overrideParams
    }
    
}

private func wrapInvalidVarioqubValue<T>(key: VarioqubFlag, _ closure: () throws -> T) throws -> T {
    do {
        return try closure()
    } catch let e {
        throw VarioqubError.invalidVarioqubValue(key: key, underlyingError: e)
    }
}
