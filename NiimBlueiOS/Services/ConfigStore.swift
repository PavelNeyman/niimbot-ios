import Foundation
import Combine

/// Хранилище конфигурации приложения
final class ConfigStore: ObservableObject {
    
    // MARK: - Properties
    
    private let configKey = "com.niimblue.config"
    private let appConfig = AppConfig()
    private var config: AppConfig
    @Published var language: String
    @Published var defaultPrinter: PrinterInfo?
    @Published var defaultUnits: LabelUnit
    @Published var defaultFont: String
    @Published var defaultIcon: String
    @Published var version: String
    @Published var buildNumber: Int
    
    // MARK: - Initialization
    
    init() {
        config = AppConfig()
        
        // Загрузка из UserDefaults
        loadFromUserDefaults()
        
        // Инициализация Published properties
        language = config.language
        defaultPrinter = config.defaultPrinter
        defaultUnits = config.defaultUnits
        defaultFont = config.defaultFont
        defaultIcon = config.defaultIcon
        version = config.version
        buildNumber = config.buildNumber
    }
    
    deinit {
        saveToUserDefaults()
    }
    
    // MARK: - UserDefaults Operations
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: configKey) {
            do {
                let decoder = JSONDecoder()
                let loadedConfig = try decoder.decode(AppConfig.self, from: data)
                
                config = AppConfig(
                    language: loadedConfig.language,
                    defaultPrinter: loadedConfig.defaultPrinter,
                    defaultUnits: loadedConfig.defaultUnits,
                    defaultFont: loadedConfig.defaultFont,
                    defaultIcon: loadedConfig.defaultIcon,
                    version: loadedConfig.version,
                    buildNumber: loadedConfig.buildNumber
                )
            } catch {
                print("Error loading config: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(config)
            UserDefaults.standard.set(data, forKey: configKey)
        } catch {
            print("Error saving config: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Updates
    
    func setLanguage(_ language: String) {
        self.language = language
        config.language = language
        saveToUserDefaults()
    }
    
    func setDefaultPrinter(_ printer: PrinterInfo?) {
        self.defaultPrinter = printer
        config.defaultPrinter = printer
        saveToUserDefaults()
    }
    
    func setDefaultUnits(_ units: LabelUnit) {
        self.defaultUnits = units
        config.defaultUnits = units
        saveToUserDefaults()
    }
    
    func setDefaultFont(_ font: String) {
        self.defaultFont = font
        config.defaultFont = font
        saveToUserDefaults()
    }
    
    func setDefaultIcon(_ icon: String) {
        self.defaultIcon = icon
        config.defaultIcon = icon
        saveToUserDefaults()
    }
    
    // MARK: - Helpers
    
    func isLanguageEnglish() -> Bool {
        language == "en"
    }
    
    func isLanguageRussian() -> Bool {
        language == "ru"
    }
}
