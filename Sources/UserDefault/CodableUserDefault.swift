import Foundation

@available(iOS 2.0, OSX 10.0, tvOS 9.0, watchOS 2.0, *)
@propertyWrapper
public struct CodableUserDefault<Value: Codable> {

    // MARK: - Private properties

    private let key: String
    private let defaultValue: Value
    private var userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: - Public

    public var wrappedValue: Value {
        get {
            let value = userDefaults.object(Value.self, for: key, usingDecoder: decoder)
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(object: newValue, forKey: key, usingEncoder: encoder)
            }
        }
    }

    // MARK: - Initialization

    public init(_ key: String,
         defaultValue: Value,
         userDefaults: UserDefaults = .standard,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {

        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder

        if let defaultValueAsOptional = defaultValue as? AnyOptional,
           !defaultValueAsOptional.isNil,
           let data = try? encoder.encode(defaultValue) {
            self.userDefaults.register(defaults: [key: data])
        }
    }
}

// MARK: - Convenience init for optionals

public extension CodableUserDefault where Value: ExpressibleByNilLiteral {
    init(key: String) {
        self.init(key, defaultValue: nil)
    }
}
