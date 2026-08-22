import Foundation

/// Конфигурация приложения
struct AppConfig: Codable, Identifiable {
    let id: UUID
    var language: String = "ru"
    var defaultPrinter: PrinterInfo?
    var defaultUnits: LabelUnit = .mm
    var defaultFont: String = "System"
    var defaultIcon: String = "plus"
    var version: String = "1.0.0"
    var buildNumber: Int = 1
    
    enum CodingKeys: String, CodingKey {
        case id, language, defaultPrinter, defaultUnits, defaultFont, defaultIcon, version, buildNumber
    }
    
    init(
        id: UUID = UUID(),
        language: String = "ru",
        defaultPrinter: PrinterInfo? = nil,
        defaultUnits: LabelUnit = .mm,
        defaultFont: String = "System",
        defaultIcon: String = "plus",
        version: String = "1.0.0",
        buildNumber: Int = 1
    ) {
        self.id = id
        self.language = language
        self.defaultPrinter = defaultPrinter
        self.defaultUnits = defaultUnits
        self.defaultFont = defaultFont
        self.defaultIcon = defaultIcon
        self.version = version
        self.buildNumber = buildNumber
    }
}
