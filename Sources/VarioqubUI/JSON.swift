
import DivKit

enum JSONDecodingError: Error {
    case unknownValue(path: [CodingKey])
}

enum JSON: Equatable, Hashable {
    case null
    case bool(Bool)
    case integer(Int)
    case double(Double)
    case string(String)
    case array([JSON])
    case object([String: JSON])
    
    init?(_ obj: Any?) {
        if let obj = obj {
            if let bool = obj as? Bool {
                self = .bool(bool)
            } else if let int = obj as? Int {
                self = .integer(int)
            } else if let double = obj as? Double {
                self = .double(double)
            } else if let string = obj as? String {
                self = .string(string)
            } else if let array = obj as? [Any] {
                self = .array(array.compactMap { JSON($0) })
            } else if let object = obj as? [String: Any] {
                self = .object(object.compactMapValues { JSON($0) })
            } else {
                return nil
            }
        } else {
            self = .null
        }
    }
    
    var value: Any? {
        switch self {
        case .null:
            return nil
        case let .bool(value):
            return value
        case let .integer(value):
            return value
        case let .double(value):
            return value
        case let .string(value):
            return value
        case let .array(value):
            return value.map { $0.value }
        case let .object(value):
            return value.compactMapValues { $0.value }
        }
    }
}

extension JSON: Decodable {
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        if let object = try? container.decode([String: JSON].self) {
            self = .object(object)
        } else if let array = try? container.decode([JSON].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let integer = try? container.decode(Int.self) {
            self = .integer(integer)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw JSONDecodingError.unknownValue(path: container.codingPath)
        }
        
    }
    
}

extension JSON {
    
    mutating func merge(with other: JSON) {
        switch (self, other) {
        case (.object(let obj), .object(let otherObj)):
            var merged = obj
            
            for (key, value) in otherObj {
                if var mergedValue = merged[key] {
                    mergedValue.merge(with: value)
                    merged[key] = mergedValue
                } else {
                    merged[key] = value
                }
            }
            
            self = .object(merged)
        default:
            self = other
        }
    }
    
}

extension JSON {
    
    var divVariableValue: AnyHashable? {
        switch self {
        case .bool(let b):
            return AnyHashable(b)
        case .integer(let i):
            return AnyHashable(i)
        case .double(let d):
            return AnyHashable(d)
        case .string(let s):
            return AnyHashable(s)
        case .array(let a):
            return a.compactMap(\.divVariableValue)
        case .object(let o):
            return o.compactMapValues(\.divVariableValue)
        case .null:
            return nil
        }
    }
    
}

extension JSON {
    
    var boolValue: Bool? {
        switch self {
        case .bool(let b): return b
        default: return nil
        }
    }
    
    var intValue: Int? {
        switch self {
        case .integer(let i): return i
        default: return nil
        }
    }
    
    var stringValue: String? {
        switch self {
        case .string(let s): return s
        default: return nil
        }
    }
    
    var doubleValue: Double? {
        switch self {
        case .double(let d): return d
        default: return nil
        }
    }
    
    var arrayValue: [JSON]? {
        switch self {
        case .array(let a): return a
        default: return nil
        }
    }
    
    var dictionaryValue: [String: JSON]? {
        switch self {
        case .object(let o): return o
        default: return nil
        }
    }
    
}
