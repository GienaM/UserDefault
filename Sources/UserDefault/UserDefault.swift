import Foundation

@available(iOS 2.0, OSX 10.0, tvOS 9.0, watchOS 2.0, *)
@propertyWrapper
public struct UserDefault<Value> {

    // MARK: - Private properties

    private let key: String
    private let defaultValue: Value
    private var userDefaults: UserDefaults

    // MARK: - Public properties

    public var wrappedValue: Value {
        get {
            let value = UserDefaults.standard.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.setValue(newValue, forKey: key)
            }
        }
    }

    // MARK: - Initialization

    public init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [key: defaultValue])
    }
}

// MARK: - Convenience init for optionals

public extension UserDefault where Value: ExpressibleByNilLiteral {
    init(key: String) {
        self.init(key, defaultValue: nil, userDefaults: .standard)
    }
}

// MARK: - AnyOptional

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
