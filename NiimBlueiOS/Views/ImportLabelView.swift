import SwiftUI

struct ImportLabelView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var labelStorage: LabelStorage
    
    @State private var selectedFile: URL?
    @State private var importStatus: ImportStatus = .idle
    @State private var importMessage: String?
    @State private var loadedTemplate: ExportedLabelTemplate?
    @State private var objectCount: Int = 0
    @State private var showEditSheet = false
    
    enum ImportStatus {
        case idle
        case selecting
        case importing
        case success
        case error
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "doc.badge.json")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Импорт этикетки")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Выберите JSON-файл для импорта")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if importStatus == .idle {
                    HStack(spacing: 12) {
                        Button(action: {
                            showFilePicker()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            
                            Text("Выбрать файл")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Отмена")
                                .font(.headline)
                        }
                        .buttonStyle(.bordered)
                    }
                } else                 if importStatus == .success {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Импорт успешен!")
                            .font(.headline)
                        
                        if let template = loadedTemplate {
                            Text(template.name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Объектов: \(objectCount)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    showEditSheet = true
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                    
                                    Text("Редактировать")
                                        .font(.headline)
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button(action: {
                                    // Экспортировать
                                    exportLabel(template)
                                    dismiss()
                                }) {
                                    Image(systemName: "arrow.up.to.line.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.green)
                                    
                                    Text("Экспорт")
                                        .font(.headline)
                                }
                                .buttonStyle(.bordered)
                                
                                Button(action: {
                                    labelStorage.deleteLabel(at: labelStorage.savedLabels.firstIndex(where: { $0.id == template.id }) ?? 0)
                                    dismiss()
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.red)
                                    
                                    Text("Удалить")
                                        .font(.headline)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                } else if let error = importMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        
                        Text("Ошибка импорта")
                            .font(.headline)
                        
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .navigationTitle("Импорт JSON")
            .onAppear {
                // Загружаем загруженный файл
                if let file = selectedFile {
                    // Проверка файла
                    if !FileManager.default.fileExists(atPath: file.path) {
                        importStatus = .error
                        importMessage = "Файл не существует"
                        return
                    }
                    
                    // Попытка импорта
                    if let template = labelStorage.importLabel(from: file) {
                        importStatus = .success
                        importMessage = nil
                        loadedTemplate = template
                        objectCount = template.objects.count
                    } else {
                        importStatus = .error
                        importMessage = "Ошибка при чтении JSON файла"
                    }
                }
            }
            .sheet(isPresented: $showEditSheet) { template in
                LoadLabelSheet(template: template, labelStorage: labelStorage)
            }
        }
    }
    
    private func showFilePicker() {
        selectedFile = nil
        importStatus = .selecting
        importMessage = nil
        loadedTemplate = nil
        
        // Используем fileImporter в NavigationView
        dismiss()
    }
    
    private func exportLabel(_ template: ExportedLabelTemplate) {
        let exportURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Exports")
            .appendingPathComponent("\(template.id.uuidString).zpl")
        
        do {
            try FileManager.default.createDirectory(at: exportURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            
            // Генерируем ZPL код
            let zpl = ZPLGenerator.generateZPL(template)
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            let jsonData = try encoder.encode(template)
            
            // Сохраняем в JSON для экспорта
            try jsonData.write(to: exportURL, options: .atomicWrite)
            
            print("Exported to: \(exportURL)")
        } catch {
            print("Export failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Extension
extension ImportLabelView {
    private var currentStatus: ImportStatus {
        importStatus
    }
}

#Preview {
    ImportLabelView(
        labelStorage: LabelStorage()
    )
}
