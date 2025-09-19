
import Varioqub

final class VarioqubInstanceMock: VarioqubFlagProvider, VarioqubResourcesProvider {
    
    typealias GetHandler = (VarioqubFlag) -> Void
    typealias ResourceHandler = (VarioqubResourceKey) -> Void
    
    var allItems: [VarioqubFlag : VarioqubConfigValue] = [:]
    var resources: [VarioqubResourceKey: VarioqubResource] = [:]
    
    var getHandler: GetHandler?
    var getHandlers: [VarioqubFlag: GetHandler] = [:]
    var getCounters: [VarioqubFlag: Int] = [:]
    
    var resourceHandler: ResourceHandler?
    var resourceHandlers: [VarioqubResourceKey: ResourceHandler] = [:]
    var resourceCounters: [VarioqubResourceKey: Int] = [:]
    
    func get<T>(for flag: VarioqubFlag, type: T.Type, defaultValue: T?) -> T where T : VarioqubInitializableByValue {
        getHandler?(flag)
        getHandlers[flag]?(flag)
        
        getCounters[flag] = (getCounters[flag] ?? 0) + 1
        
        let value = allItems[flag]
        let result: T = value?.value.flatMap(type.init(value:)) ?? defaultValue ?? type.defaultValue
        return result
    }

    func getValue(for flag: VarioqubFlag) -> VarioqubConfigValue {
        getHandler?(flag)
        getHandlers[flag]?(flag)
        
        getCounters[flag] = (getCounters[flag] ?? 0) + 1
        
        return allItems[flag] ?? VarioqubConfigValue(source: .defaultValue, value: nil, triggeredTestID: nil)
    }

    func resource(for key: VarioqubResourceKey) -> VarioqubResource? {
        resourceHandler?(key)
        resourceHandlers[key]?(key)
        
        resourceCounters[key] = (resourceCounters[key] ?? 0) + 1
        
        return resources[key]
    }

    
    
    
}
