extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

internal protocol AnyOptional {
    var isNil: Bool { get }
}
