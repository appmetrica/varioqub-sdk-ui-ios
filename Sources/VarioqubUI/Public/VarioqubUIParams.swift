
import DivKit

public struct VarioqubUIParams: Equatable {
    var _values: [String: JSON]
    
    public init() {
        self._values = [:]
    }
    
    init(_values: [String : JSON]) {
        self._values = _values
    }
    
    mutating func append(_ key: String, _ value: JSON?) {
        _values[key] = value
    }
    
    public mutating func clear(_ key: String) {
        _values[key] = nil
    }
    
    public mutating func append(_ key: String, boolValue: Bool) {
        _values[key] = .bool(boolValue)
    }
    
    public mutating func append(_ key: String, intValue: Int) {
        _values[key] = .integer(intValue)
    }
    
    public mutating func append(_ key: String, doubleValue: Double) {
        _values[key] = .double(doubleValue)
    }
    
    public mutating func append(_ key: String, stringValue: String) {
        _values[key] = .string(stringValue)
    }
    
    public mutating func append(_ key: String, arrayValue: [Any]) {
        _values[key] = .array(arrayValue.compactMap { JSON($0) })
    }
    
    public mutating func append(_ key: String, objectValue: [String: Any]) {
        _values[key] = .object(objectValue.compactMapValues { JSON($0) })
    }
    
    public func value(for key: String) -> Any? {
        _values[key]?.value
    }
    
    public var keys: Set<String> {
        Set(_values.keys)
    }
    
    public var values: [String: Any?] {
        _values.compactMapValues { $0.value }
    }
    
    public mutating func merge(with other: VarioqubUIParams) {
        other._values.forEach {
            if var currentValue = self._values[$0.key] {
                currentValue.merge(with: $0.value)
                _values[$0.key] = currentValue
            } else {
                _values[$0.key] = $0.value
            }
        }
    }
}

extension VarioqubUIParams {
    
    var divKitDictionary: DivDictionary {
        return _values.compactMapValues { $0.divVariableValue }
    }
    
}
