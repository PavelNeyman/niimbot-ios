import SwiftUI

struct SavedLabelsView: View {
    @StateObject private var labelStorage = LabelStorage()
    @State private var showSaveSheet = false
    @State private var newLabelName = ""
    @State private var selectedTemplate: ExportedLabelTemplate?
    @State private var showCsvImport = false
    @State private var showJsonImport = false
    @State private var showImportLabel = false
    
    var body: some View {
        NavigationStack {
            Group {
                if labelStorage.savedLabels.isEmpty {
                    EmptySavedLabelsView()
                } else {
                    LabelList(
                        templates: labelStorage.savedLabels,
                        selectedTemplate: $selectedTemplate
                    )
                }
            }
            .navigationTitle("Сохраненные метки")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showSaveSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title2)
                    }
                    
                    Button(action: {
                        showCsvImport = true
                    }) {
                        Image(systemName: "doc.text.badge.plus")
                            .font(.title2)
                    }
                    
                    Button(action: {
                        showImportLabel = true
                    }) {
                        Image(systemName: "doc.badge.json")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showSaveSheet) {
                SaveLabelSheet(
                    labelStorage: labelStorage,
                    name: $newLabelName
                )
            }
            .sheet(isPresented: $showCsvImport) {
                CsvImportView(
                    onImport: { csvParams in
                        print("CSV imported: \(csvParams.count) files")
                    },
                    onCancel: {
                        print("CSV import cancelled")
                    }
                )
            }
            .fileImporter(
                isPresented: $showCsvImport,
                allowedContentTypes: [.csv],
                allowsMultipleSelection: true
            ) { result in
                switch result {
                case .success(let selectedFiles):
                    print("Selected \(selectedFiles.count) CSV files")
                case .failure(let error):
                    print("CSV import failed: \(error.localizedDescription)")
                }
            }
            .sheet(isPresented: $showImportLabel) {
                ImportLabelView(
                    labelStorage: labelStorage
                )
            }
            .fileImporter(
                isPresented: $showImportLabel,
                allowedContentTypes: [.json],
                allowsMultipleSelection: true
            ) { result in
                switch result {
                case .success(let selectedFiles):
                    if !selectedFiles.isEmpty {
                        showImportLabel = true
                    }
                case .failure(let error):
                    print("JSON import failed: \(error.localizedDescription)")
                }
            }
            .sheet(item: $selectedTemplate) { template in
                LoadLabelSheet(template: template, labelStorage: labelStorage)
            }
            .onAppear {
                labelStorage.loadAllLabels()
            }
        }
    }
}

// MARK: - Empty Saved Labels View

struct EmptySavedLabelsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Нет сохраненных меток")
                .font(.title2)
                .foregroundColor(.primary)
            
            Text("Нажмите + чтобы сохранить новую метку")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {}) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Label List

struct LabelList: View {
    let templates: [ExportedLabelTemplate]
    @Binding var selectedTemplate: ExportedLabelTemplate?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(templates) { template in
                    LabelRow(
                        template: template,
                        selected: selectedTemplate?.id == template.id
                    )
                    .onTapGesture {
                        selectedTemplate = template
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Label Row

struct LabelRow: View {
    let template: ExportedLabelTemplate
    let selected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.title2)
                .foregroundColor(selected ? .blue : .secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(template.name)
                    .font(.headline)
                
                Text(formatDate(template.createdAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(selected ? Color.blue.opacity(0.1) : Color(.systemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Save Label Sheet

struct SaveLabelSheet: View {
    @ObservedObject var labelStorage: LabelStorage
    @Binding var name: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempName = "Новая метка"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Сохранить метку")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Введите имя для метки")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Имя метки", text: $tempName)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.words)
                
                HStack(spacing: 16) {
                    Button(action: {
                        if tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            return
                        }
                        
                        let template = labelStorage.saveLabel(
                            name: tempName,
                            objects: [],
                            labelParams: LabelParams()
                        )
                        
                        name = template.name
                        
                        dismiss()
                    }) {
                        Button("Сохранить") {
                            if tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                return
                            }
                            
                            let template = labelStorage.saveLabel(
                                name: tempName,
                                objects: [],
                                labelParams: LabelParams()
                            )
                            
                            name = template.name
                            
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Отмена")
                            .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
            .navigationTitle("Сохранить метку")
        }
    }
}

// MARK: - Load Label Sheet

struct LoadLabelSheet: View {
    let template: ExportedLabelTemplate
    @ObservedObject var labelStorage: LabelStorage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Загрузить метку")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("\(template.name)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("Действия")
                    .font(.headline)
                
                HStack(spacing: 16) {
                    Button(action: {
                        // Загрузить метку в редактор
                        dismiss()
                    }) {
                        Button("Загрузить в редактор") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button(action: {
                        // Экспортировать метку
                        let exportURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            .appendingPathComponent("Exports")
                            .appendingPathComponent("\(template.id.uuidString).zpl")
                        
                        try? FileManager.default.createDirectory(at: exportURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                        
                        // Здесь должна быть реализация экспорта в ZPL
                        dismiss()
                    }) {
                        Button("Экспорт") {
                            let exportURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                .appendingPathComponent("Exports")
                                .appendingPathComponent("\(template.id.uuidString).zpl")
                            
                            try? FileManager.default.createDirectory(at: exportURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                            
                            // Здесь должна быть реализация экспорта в ZPL
                            
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Button(action: {
                        // Удалить метку
                        labelStorage.deleteLabel(at: labelStorage.savedLabels.firstIndex(where: { $0.id == template.id }) ?? 0)
                        dismiss()
                    }) {
                        Button("Удалить") {
                            labelStorage.deleteLabel(at: labelStorage.savedLabels.firstIndex(where: { $0.id == template.id }) ?? 0)
                            dismiss()
                        }
                        .tint(.red)
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
            .navigationTitle("Метка")
        }
    }
}

#Preview {
    SavedLabelsView()
}
