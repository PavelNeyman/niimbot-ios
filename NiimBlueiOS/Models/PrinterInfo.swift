import Foundation

/// Информация о NIIMBOT принтере
struct PrinterInfo: Codable, Identifiable {
    let id: UUID
    var model: String
    var serialNumber: String?
    var firmwareVersion: String?
    var ipAddress: String?
    var port: Int?
    var isOnline: Bool
    var capabilities: [String: String]
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case model, serialNumber, firmwareVersion, ipAddress, port, isOnline, capabilities, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.model = values.decodeIfPresent(.model) ?? "Unknown"
        self.serialNumber = values.decodeIfPresent(.serialNumber)
        self.firmwareVersion = values.decodeIfPresent(.firmwareVersion)
        self.ipAddress = values.decodeIfPresent(.ipAddress)
        self.port = values.decodeIfPresent(.port)
        self.isOnline = values.decodeIfPresent(.isOnline) ?? false
        self.capabilities = values.decodeIfPresent(.capabilities) ?? [:]
        self.timestamp = Date()
    }
    
    init() {
        self.id = UUID()
        self.model = "Unknown"
        self.serialNumber = nil
        self.firmwareVersion = nil
        self.ipAddress = nil
        self.port = nil
        self.isOnline = false
        self.capabilities = [:]
        self.timestamp = Date()
    }
}

/// Метаданные модели принтера
struct PrinterModelMeta: Codable, Identifiable {
    let id: UUID
    let name: String
    let modelNumber: String
    let manufacturer: String
    let releaseDate: Date?
    let firmwareVersions: [String]
    let supportedFeatures: [String]
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case name, modelNumber, manufacturer, releaseDate, firmwareVersions, supportedFeatures, description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.name = values.decodeIfPresent(.name) ?? "Unknown"
        self.modelNumber = values.decodeIfPresent(.modelNumber) ?? "Unknown"
        self.manufacturer = values.decodeIfPresent(.manufacturer) ?? "NIIMBOT"
        self.releaseDate = values.decodeIfPresent(.releaseDate)
        self.firmwareVersions = values.decodeIfPresent(.firmwareVersions) ?? []
        self.supportedFeatures = values.decodeIfPresent(.supportedFeatures) ?? []
        self.description = values.decodeIfPresent(.description)
    }
    
    init() {
        self.id = UUID()
        self.name = "Unknown Model"
        self.modelNumber = "Unknown"
        self.manufacturer = "NIIMBOT"
        self.releaseDate = nil
        self.firmwareVersions = []
        self.supportedFeatures = []
        self.description = nil
    }
}

/// Данные heartbeat
struct HeartbeatData: Codable {
    let timestamp: Date
    let isAlive: Bool
    let batteryLevel: Int?
    let temperature: Int?
    
    enum CodingKeys: String, CodingKey {
        case timestamp, isAlive, batteryLevel, temperature
    }
    
    init() {
        self.timestamp = Date()
        self.isAlive = true
        self.batteryLevel = nil
        self.temperature = nil
    }
}
