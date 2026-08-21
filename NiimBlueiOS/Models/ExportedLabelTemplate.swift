import Foundation

/// Экспортируемый шаблон этикетки
struct ExportedLabelTemplate: Codable, Identifiable {
    let id: UUID
    var name: String
    var date: Date
    var objects: [LabelObject]
    var labelParams: LabelParams
    
    var createdAt: Date {
        date
    }
    
    var updatedAt: Date {
        date
    }
    
    // MARK: - Codable Conformance
    
    enum CodingKeys: String, CodingKey {
        case id, name, date, objects, labelParams
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        date: Date = Date(),
        objects: [LabelObject],
        labelParams: LabelParams
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.objects = objects
        self.labelParams = labelParams
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = values.decodeIfPresent(.id) ?? UUID()
        self.name = values.decodeIfPresent(.name) ?? "Безымянная этикетка"
        self.date = values.decodeIfPresent(.date) ?? Date()
        self.objects = try? values.decode([LabelObject].self) ?? []
        self.labelParams = try? values.decode(LabelParams.self) ?? LabelParams()
    }
}
