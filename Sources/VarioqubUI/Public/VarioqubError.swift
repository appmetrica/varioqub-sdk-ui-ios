
import Varioqub

public enum VarioqubError: Error {
    case invalidVarioqubValue(key: VarioqubFlag, underlyingError: Error?)
    case resourceKeyNotFound(key: VarioqubResourceKey)
    case conversionFailed
}
