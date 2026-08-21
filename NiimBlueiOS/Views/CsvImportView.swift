//
//  CsvImportView.swift
//  NiimBlueiOS
//
//  UI для импорта CSV файлов в редактор этикеток
//

import SwiftUI
import UniformTypeIdentifiers

/// Представление импорта CSV файлов
struct CsvImportView: View {
    @State private var selectedFile: FilePickerResult?
    @State private var showPreview: Bool = false
    @State private var csvParams: CsvParams?
    @State private var errorMessage: String?
    @State private var previewText: String = ""
    @State private var selectedRows: [CsvParams] = []
    
    let onImport: ([CsvParams]) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Импорт CSV")
                .font(.title2)
                .fontWeight(.semibold)
            
            if selectedFile != nil {
                // Индикатор загрузки
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            // Сообщение об ошибке
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            if showPreview && csvParams != nil {
                // Предварительный просмотр
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 300))
                    ], spacing: 10) {
                        ForEach(csvParams!.rows.enumerated(), id: \.offset) { index, row in
                            Text(row.joined(separator: "  "))
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxHeight: 400)
            }
            
            // Кнопки действий
            VStack(spacing: 10) {
                Button(action: {
                    onImport(selectedRows)
                }) {
                    Text("Импортировать")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .disabled(selectedRows.isEmpty)
                
                Button(action: {
                    onCancel()
                }) {
                    Text("Отмена")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .onAppear {
            if let file = selectedFile {
                importCSV(file: file)
            }
        }
    }
    
    /// Импортирует CSV файл
    private func importCSV(file: FilePickerResult) {
        guard let data = file.data else {
            errorMessage = "Не удалось прочитать файл"
            return
        }
        
        // Парсинг CSV
        let result = CsvParser.parse(data: data)
        
        if result.success {
            selectedRows.append(result.params!)
            errorMessage = nil
            
            // Показать превью
            showPreview = true
            
            // Отобразить заголовки
            previewText = result.params!.headers.joined(separator: "  ")
        } else {
            errorMessage = result.error
        }
    }
}

/// Результат выбора файла
struct FilePickerResult {
    let url: URL
    let name: String
    let data: Data?
    let type: UTType?
}

#Preview {
    NavigationStack {
        CsvImportView(
            onImport: { rows in
                print("Imported \(rows.count) CSV files")
            },
            onCancel: {
                print("Import cancelled")
            }
        )
        .navigationTitle("Импорт CSV")
    }
}
