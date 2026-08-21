import Foundation

/// Задача печати
struct PrintTask: Codable, Identifiable {
    let id: UUID
    var labelTemplate: ExportedLabelTemplate
    var quantity: Int
    var density: Int
    var speed: Int
    
    init(
        id: UUID = UUID(),
        labelTemplate: ExportedLabelTemplate,
        quantity: Int = 1,
        density: Int = 256,
        speed: Int = 5
    ) {
        self.id = id
        self.labelTemplate = labelTemplate
        self.quantity = quantity
        self.density = density
        self.speed = speed
    }
    
    // MARK: - Codable Conformance
    
    enum CodingKeys: String, CodingKey {
        case id, labelTemplate, quantity, density, speed
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = values.decodeIfPresent(.id) ?? UUID()
        self.labelTemplate = try? values.decode(ExportedLabelTemplate.self) ?? ExportedLabelTemplate(
            name: "Безымянная этикетка",
            objects: [],
            labelParams: LabelParams()
        )
        self.quantity = values.decodeIfPresent(.quantity) ?? 1
        self.density = values.decodeIfPresent(.density) ?? 256
        self.speed = values.decodeIfPresent(.speed) ?? 5
    }
}

/// Параметры печати этикетки
struct PrintParams: Codable {
    var quantity: Int
    var density: Int
    var speed: Int
    
    enum CodingKeys: String, CodingKey {
        case quantity, density, speed
    }
    
    init(
        quantity: Int = 1,
        density: Int = 256,
        speed: Int = 5
    ) {
        self.quantity = quantity
        self.density = density
        self.speed = speed
    }
}
