import SwiftUI

struct JsonImportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var labelStorage: LabelStorage
    @Binding var onImport: () -> Void
    @Binding var onCancel: () -> Void
    
    @State private var selectedFiles: [URL] = []
    @State private var importStatus: ImportStatus = .idle
    @State private var importMessage: String?
    
    enum ImportStatus {
        case idle
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
                
                Text("Импорт этикеток")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Выберите JSON-файлы для импорта")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                List {
                    if importStatus == .idle {
                        ForEach(selectedFiles) { file in
                            Label(file.lastPathComponent, systemImage: "file.json")
                        }
                    } else if importStatus == .success {
                        Text(importMessage ?? "Импорт успешно!")
                            .font(.headline)
                    } else if let error = importMessage {
                        Text(error)
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                
                HStack(spacing: 16) {
                    Button(action: {
                        selectedFiles = []
                        importStatus = .idle
                        importMessage = nil
                    }) {
                        Text("Закрыть")
                            .buttonStyle(.bordered)
                    }
                    
                    if importStatus == .idle {
                        Button(action: {
                            importStatus = .importing
                            importMessage = nil
                        }) {
                            Text("Импорт")
                                .buttonStyle(.borderedProminent)
                                .disabled(importStatus == .importing)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Импорт JSON")
            .onAppear {
                // Загружаем выбранные файлы
                // (они уже загружены из fileImporter)
            }
            .onDisappear {
                if importStatus == .success || importStatus == .error {
                    // Закрыть sheet
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Extension
extension JsonImportView {
    private var currentFiles: [URL] {
        if importStatus == .idle {
            return selectedFiles
        } else {
            return []
        }
    }
}

#Preview {
    JsonImportView(
        onImport: {},
        onCancel: {}
    )
    .environmentObject(LabelStorage())
}
