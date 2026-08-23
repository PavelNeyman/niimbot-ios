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
    @State private var csvParams: CsvParams?
    
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
                    csvParams: csvParams,
                    onPrint: { params in
                        print("Batch print: \(params.batchCount) records")
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
            showError("Пожалуйста, выберите хотя бы один файл")
            return
        }
        
        importStatus = .parsing
        importMessage = nil
        loadedTemplate = nil
        
        // Валидация файлов
        if let invalidFiles = validateCSVFiles() {
            showError("Ошибка валидации:\(invalidFiles.joined(separator: ", "))")
            return
        }
        
        // Парсинг CSV файлов
        var fileErrors: [String] = []
        
        for url in selectedFiles {
            let filePath = url.path
            
            // Валидация пути к файлу
            if FileManager.default.fileExists(atPath: filePath) {
                // Проверка на CSV файл
                if url.pathExtension != "csv" && url.pathExtension != ".csv" {
                    fileErrors.append("Некорректное расширение файла: \(url.lastPathComponent)")
                    continue
                }
                
                if let result = CsvParser.parse(filePath: filePath) {
                    if result.success {
                        if let params = result.params {
                            importStatus = .success
                            importMessage = nil
                            
                            // Сохраняем CSV параметры для последующего использования
                            csvParams = params
                            
                            // Создаем LabelTemplate из CSV данных
                            let template = createLabelTemplateFromCsv(params)
                            
                            if let template = template {
                                loadedTemplate = template
                            } else {
                                importStatus = .error
                                importMessage = "Не удалось создать этикетку из CSV: \(url.lastPathComponent)"
                            }
                        } else {
                            fileErrors.append("Парсинг файла \(url.lastPathComponent): не удалось извлечь параметры")
                        }
                    } else {
                        fileErrors.append("Ошибка парсинга файла: \(result.error ?? "Неизвестная ошибка")")
                    }
                } else {
                    fileErrors.append("Ошибка чтения файла \(url.lastPathComponent): \(result.error ?? "Неизвестная ошибка")")
                }
            } else {
                fileErrors.append("Файл не найден: \(url.lastPathComponent)")
            }
        }
        
        // Обработка ошибок
        if !fileErrors.isEmpty {
            importStatus = .error
            let errorMessage = "Ошибка импорта: \(\(fileErrors.joined(separator: "; ")))"
            importMessage = errorMessage
        }
    }
    
    /// Валидация файлов CSV перед импортом
    private func validateCSVFiles() -> [String] {
        var errors: [String] = []
        
        for url in selectedFiles {
            let filePath = url.path
            
            // Проверка существования файла
            if !FileManager.default.fileExists(atPath: filePath) {
                errors.append("Файл не существует: \(url.lastPathComponent)")
                continue
            }
            
            // Проверка расширения
            if url.pathExtension != "csv" && url.pathExtension != ".csv" {
                errors.append("Некорректное расширение файла: \(url.pathExtension) (ожидалось .csv)")
                continue
            }
            
            // Проверка размера файла
            if FileManager.default.fileSize(forURL: url) == 0 {
                errors.append("Файл пуст: \(url.lastPathComponent)")
                continue
            }
            
            // Проверка читаемости файла
            if let contents = try? String(contentsOf: url, encoding: .utf8) {
                // Проверка на корректный формат CSV (должен содержать хотя бы одну строку)
                if contents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    errors.append("Файл пуст или некорректен: \(url.lastPathComponent)")
                }
            } else {
                errors.append("Ошибка при чтении файла: \(url.lastPathComponent)")
            }
        }
        
        return errors
    }
    
    /// Показывает сообщение об ошибке
    private func showError(_ message: String) {
        importStatus = .error
        importMessage = message
        // Можно добавить toast notification
        print("Ошибка импорта CSV: \(message)")
    }
    
    /// Создает LabelTemplate из данных CSV
    private func createLabelTemplateFromCsv(_ params: CsvParams) -> ExportedLabelTemplate? {
        // Получаем количество колонок (символов в строке)
        let columnCount = CsvParser.getColumnCount(csv: params)
        
        // Создаем массив объектов из CSV данных
        var objects: [LabelObject] = []
        
        // Создаем текстовый объект с заголовками CSV
        let headerContent = params.headers.map { "\($0)" }.joined(separator: " | ")
        let headerObj = LabelObject(
            type: .text,
            content: headerContent,
            labelProps: LabelProps(
                x: 10,
                y: 10,
                width: 100,
                height: 20,
                textParams: TextParams(
                    content: headerContent,
                    fontSize: 10,
                    fontFamily: "Arial",
                    color: "#000000",
                    justify: .center
                )
            )
        )
        objects.append(headerObj)
        
        // Создаем текстовые объекты для каждой строки данных
        for (index, row) in params.rows.enumerated() {
            let rowCount = index + 1
            let rowContent = row.map { "\($0)" }.joined(separator: " | ")
            
            let obj = LabelObject(
                type: .text,
                content: rowContent,
                labelProps: LabelProps(
                    x: 10,
                    y: 35 + CGFloat(rowCount) * 25,
                    width: 100,
                    height: 20,
                    textParams: TextParams(
                        content: rowContent,
                        fontSize: 10,
                        fontFamily: "Arial",
                        color: "#000000",
                        justify: .center
                    )
                )
            )
            objects.append(obj)
        }
        
        // Создаем LabelTemplate
        let template = ExportedLabelTemplate(
            name: params.fileName,
            date: Date(),
            objects: objects,
            labelParams: LabelParams()
        )
        
        return template
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
