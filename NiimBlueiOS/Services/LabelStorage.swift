import Foundation
import SwiftUI

/// Сервис для хранения и загрузки этикеток
final class LabelStorage: ObservableObject {
    
    // MARK: - Properties
    
    private let documentsDirectory: URL
    private let savedLabelsFolder: URL
    
    @Published var savedLabels: [ExportedLabelTemplate] = []
    
    // MARK: - Initialization
    
    init() {
        let fileManager = FileManager.default
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        savedLabelsFolder = documentsDirectory.appendingPathComponent("SavedLabels")
        
        // Создаем папку для сохраненных этикеток
        try? fileManager.createDirectory(at: savedLabelsFolder, withIntermediateDirectories: true)
    }
    
    // MARK: - Save Label
    
    /// Сохранить этикетку
    func saveLabel(
        name: String,
        objects: [LabelObject],
        labelParams: LabelParams
    ) -> ExportedLabelTemplate {
        let template = ExportedLabelTemplate(
            name: name,
            objects: objects,
            labelParams: labelParams
        )
        
        save(template: template)
        
        return template
    }
    
    /// Экспортировать этикетку в файл
    func exportLabel(_ template: ExportedLabelTemplate, to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        let jsonData = try encoder.encode(template)
        try jsonData.write(to: url, options: .atomicWrite)
    }
    
    /// Импорт этикетки из JSON файла
    func importLabel(from url: URL) -> ExportedLabelTemplate? {
        do {
            // Проверка существования файла
            guard FileManager.default.fileExists(atPath: url.path) else {
                print("File does not exist: \(url.path)")
                return nil
            }
            
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            
            let template = try decoder.decode(ExportedLabelTemplate.self, from: jsonData)
            
            // Проверка объектов
            if template.objects.isEmpty {
                print("Warning: Imported label has no objects")
            }
            
            // Сохраняем импорт в локальный список
            if let index = savedLabels.firstIndex(where: { $0.id == template.id }) {
                savedLabels[index] = template
            } else {
                savedLabels.append(template)
                savedLabels.sort { $0.createdAt > $1.createdAt }
            }
            
            // Обновляем список
            loadAllLabels()
            
            return template
            
        } catch {
            print("Error importing label: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Load Label
    
    /// Загрузить этикетку по имени
    func loadLabel(named name: String) -> ExportedLabelTemplate? {
        // Ищем файл с именем или частичным совпадением
        let searchName = name.lowercased().replacingOccurrences(of: " ", with: "_")
        
        for fileUrl in savedLabelsFolder.enumerating(using: .files) {
            let fileName = fileUrl.lastPathComponent.lowercased()
            if fileName == searchName || fileName.contains(searchName) {
                return load(from: fileUrl)
            }
        }
        
        return nil
    }
    
    /// Загрузить все сохраненные этикетки
    func loadAllLabels() {
        savedLabels = loadAll()
    }
    
    /// Удалить этикетку
    func deleteLabel(at index: Int) {
        guard index < savedLabels.count else { return }
        
        let deletedTemplate = savedLabels[index]
        savedLabels.remove(at: index)
        
        try? FileManager.default.removeItem(at: deletedTemplate.url)
    }
    
    // MARK: - Private Methods
    
    private func save(template: ExportedLabelTemplate) {
        let url = template.url
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            
            let jsonData = try encoder.encode(template)
            try jsonData.write(to: url, options: .atomicWrite)
            
            // Обновляем локальный список
            if let index = savedLabels.firstIndex(where: { $0.id == template.id }) {
                savedLabels[index] = template
            } else {
                savedLabels.append(template)
                savedLabels.sort { $0.createdAt > $1.createdAt }
            }
            
            // Обновляем список
            loadAllLabels()
            
        } catch {
            print("Error saving label: \(error.localizedDescription)")
        }
    }
    
    private func load(from url: URL) -> ExportedLabelTemplate? {
        do {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            let template = try decoder.decode(ExportedLabelTemplate.self, from: jsonData)
            return template
        } catch {
            print("Error loading label: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func loadAll() -> [ExportedLabelTemplate] {
        let fileManager = FileManager.default
        var templates: [ExportedLabelTemplate] = []
        
        if fileManager.fileExists(atPath: savedLabelsFolder.path) {
            do {
                let contents = try fileManager.contentsOfDirectory(at: savedLabelsFolder, includingPropertiesForKeys: nil)
                templates.removeAll { url in
                    let fileUrl = url.lastPathComponent
                    let pathExtension = url.pathExtension
                    return fileUrl.lowercased().hasSuffix(".json") == false || pathExtension.lowercased() == "json" == false
                }
                
                for fileUrl in contents {
                    if let template = load(from: fileUrl) {
                        templates.append(template)
                    }
                }
                
                templates.sort { $0.createdAt > $1.createdAt }
                
            } catch {
                print("Error loading labels: \(error.localizedDescription)")
            }
        }
        
        return templates
    }
}

// MARK: - Extension

extension ExportedLabelTemplate {
    /// URL файла этикетки
    var url: URL {
        let fileName = "\(id.uuidString)_\(name.replacingOccurrences(of: " ", with: "_")).json"
        return savedLabelsFolder.appendingPathComponent(fileName)
    }
}
