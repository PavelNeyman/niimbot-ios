import SwiftUI

struct CsvImportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var labelStorage: LabelStorage
    
    @State private var selectedFiles: [URL] = []
    @State private var importStatus: ImportStatus = .idle
    @State private var importMessage: String?
    @State private var showBatchSheet = false
    @State private var batchCount: Int = 1
    @State private var showVariableEditor = false
    
    enum ImportStatus {
        case idle
        case selecting
        case parsing
        case success
        case error
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "doc.text")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Импорт CSV")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Выберите CSV-файлы для импорта данных")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                                    if importStatus == .idle {
                    HStack(spacing: 12) {
                        Button(action: {
                            importFiles()
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
                } else if importStatus == .success {
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
                
                if importStatus == .success {
                    HStack(spacing: 16) {
                        Button(action: {
                            showBatchSheet = true
                        }) {
                            Image(systemName: "rectangle.on.rectangle")
                                .font(.title)
                                .foregroundColor(.blue)
                            
                            Text("Batch Print")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Закрыть")
                                .font(.headline)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
            .navigationTitle("Импорт CSV")
            .sheet(isPresented: $showBatchSheet) {
                CsvBatchPrintSheet(
                    count: $batchCount,
                    onPrint: { csvParams in
                        print("Batch print: \(csvParams.batchCount) records")
                    },
                    onCancel: {
                        print("Batch print cancelled")
                    }
                )
            }
            .sheet(isPresented: $showVariableEditor) {
                CsvVariableEditor(
                    onDismiss: {
                        showVariableEditor = false
                    }
                )
            }
        }
    }
    
    private func showFilePicker() {
        selectedFiles = []
        importStatus = .selecting
        importMessage = nil
        loadedTemplate = nil
        
        dismiss()
    }
    
    private func importFiles() {
        guard !selectedFiles.isEmpty else {
            return
        }
        
        importStatus = .parsing
        importMessage = nil
        
        for url in selectedFiles {
            let filePath = url.path
            if let result = CsvParser.parse(filePath: filePath) {
                if result.success {
                    if let params = result.params {
                        importStatus = .success
                        importMessage = nil
                        
                        // Создаем LabelTemplate из CSV данных
                        let template = labelStorage.saveLabel(
                            name: params.fileName,
                            objects: [], // Здесь должна быть логика создания объектов из CSV
                            labelParams: LabelParams()
                        )
                        
                        if let template = template {
                            loadedTemplate = template
                        }
                    }
                } else {
                    importStatus = .error
                    importMessage = result.error
                }
            }
        }
    }
}

// MARK: - Extension
extension CsvImportView {
    private var currentStatus: ImportStatus {
        importStatus
    }
    
    private var loadedTemplate: ExportedLabelTemplate? {
        if importStatus == .success {
            return importedTemplate
        } else {
            return nil
        }
    }
    
    private var importedTemplate: ExportedLabelTemplate? {
        if !selectedFiles.isEmpty {
            // Здесь должна быть реализация импорта из CSV
            return nil // Заглушка
        } else {
            return nil
        }
    }
}

#Preview {
    CsvImportView(
        labelStorage: LabelStorage()
    )
}
