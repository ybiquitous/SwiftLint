private enum ConfigurationKey: String {
    case severity = "severity"
    case includePublicAndOpen = "include_public_and_open"
    case customTestClasses = "custom_test_classes"
}

public struct UnusedDeclarationConfiguration: RuleConfiguration, Equatable {
    private(set) var includePublicAndOpen: Bool
    private(set) var severity: ViolationSeverity
    private(set) var customTestClasses: [String]

    public var consoleDescription: String {
        return "\(ConfigurationKey.severity.rawValue): \(severity.rawValue), " +
            "\(ConfigurationKey.includePublicAndOpen.rawValue): \(includePublicAndOpen), " +
            "\(ConfigurationKey.customTestClasses.rawValue): \(customTestClasses)"
    }

    public init(severity: ViolationSeverity, includePublicAndOpen: Bool, customTestClasses: [String]) {
        self.includePublicAndOpen = includePublicAndOpen
        self.severity = severity
        self.customTestClasses = customTestClasses
    }

    public mutating func apply(configuration: Any) throws {
        guard let configDict = configuration as? [String: Any], !configDict.isEmpty else {
            throw ConfigurationError.unknownConfiguration
        }

        for (string, value) in configDict {
            guard let key = ConfigurationKey(rawValue: string) else {
                throw ConfigurationError.unknownConfiguration
            }
            switch (key, value) {
            case (.severity, let stringValue as String):
                if let severityValue = ViolationSeverity(rawValue: stringValue) {
                    severity = severityValue
                } else {
                    throw ConfigurationError.unknownConfiguration
                }
            case (.includePublicAndOpen, let boolValue as Bool):
                includePublicAndOpen = boolValue
            case (.customTestClasses, let stringList as [String]):
                customTestClasses = stringList
            default:
                throw ConfigurationError.unknownConfiguration
            }
        }
    }
}
