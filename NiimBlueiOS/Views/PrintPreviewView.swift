import SwiftUI

/// Просмотрщик печати этикетки
struct PrintPreviewView: View {
    @StateObject private var task = PrintTask(
        labelTemplate: ExportedLabelTemplate(
            name: "Тест",
            objects: [],
            labelParams: LabelParams()
        )
    )
    @State private var zplOutput = ""
    @State private var showZPLEditor = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Параметры печати
                VStack(alignment: .leading, spacing: 15) {
                    Text("Параметры печати")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Количество: \(task.quantity)")
                        Text("Плотность: \(task.density)")
                        Text("Скорость: \(task.speed)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Просмотр ZPL кода
                VStack(alignment: .leading, spacing: 10) {
                    Text("ZPL код")
                        .font(.headline)
                    
                    Button(action: {
                        task.labelTemplate = ExportedLabelTemplate(
                            name: "Тест",
                            objects: [],
                            labelParams: LabelParams()
                        )
                        zplOutput = ZPLGenerator.generateZPL(
                            template: task.labelTemplate,
                            params: PrintParams(
                                quantity: task.quantity,
                                density: task.density,
                                speed: task.speed
                            )
                        )
                    }) {
                        Text("Обновить")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    Text(zplOutput)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .scrollContentBackground(.hidden)
                }
            }
            .padding()
            .navigationTitle("Просмотр печати")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        // Возврат в предыдущее представление
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Открыть редактор ZPL") {
                        showZPLEditor = true
                    }
                }
            }
            .sheet(isPresented: $showZPLEditor) {
                ZPLEditorView(zplCode: $zplOutput)
            }
        }
    }
}

/// Редактор ZPL кода
struct ZPLEditorView: View {
    @Binding var zplCode: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Редактор ZPL")
                    .font(.headline)
                
                TextEditor(text: $zplCode)
                    .frame(minHeight: 300)
                    .font(.system(.body, design: .monospaced))
                
                HStack {
                    Button("Сохранить") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Button("Очистить") {
                        zplCode = ""
                    }
                    .foregroundColor(.red)
                }
            }
            .padding()
            .navigationTitle("Редактор")
        }
    }
}
