import SwiftUI

struct CsvBatchPrintSheet: View {
    @Binding var count: Int
    @Environment(\.dismiss) private var dismiss
    @State private var showVariableEditor = false
    
    var onPrint: ((CsvParams) -> Void)?
    var onCancel: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "rectangle.on.rectangle")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Batch Print")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Выберите количество записей для печати")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Количество:")
                        .font(.headline)
                    
                    TextField("Количество", value: $count, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled(true)
                    
                    Button(action: {
                        count = 1
                    }) {
                        Image(systemName: "minus")
                            .font(.title)
                    }
                    
                    Button(action: {
                        count = count * 10
                    }) {
                        Image(systemName: "x10")
                            .font(.title)
                    }
                    
                    Button(action: {
                        count = 10
                    }) {
                        Image(systemName: "x10.circle.fill")
                            .font(.title)
                    }
                    
                    Button(action: {
                        count = 100
                    }) {
                        Image(systemName: "x100.circle.fill")
                            .font(.title)
                    }
                }
                
                HStack {
                    Button(action: {
                        showVariableEditor = true
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title)
                    
                        Text("Переменные")
                            .font(.headline)
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            count = 1
                        }) {
                            Text("1")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            count = 10
                        }) {
                            Text("10")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            count = 100
                        }) {
                            Text("100")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            count = 1000
                        }) {
                            Text("1000")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                HStack(spacing: 16) {
                    Button(action: {
                        onPrint?(CsvParams(batchCount: count))
                        dismiss()
                    }) {
                        Text("Печать")
                            .buttonStyle(.borderedProminent)
                    }
                    
                    Button(action: {
                        onCancel?()
                        dismiss()
                    }) {
                        Text("Отмена")
                            .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
            .navigationTitle("Batch Print")
            .sheet(isPresented: $showVariableEditor) {
                CsvVariableEditor(
                    onDismiss: {
                        showVariableEditor = false
                    }
                )
            }
        }
    }
}

// MARK: - CsvVariableEditor

struct CsvVariableEditor: View {
    @Environment(\.dismiss) private var dismiss
    @State private var variables: [String: String] = [:]
    
    var onDismiss: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(variables) { (key, value) in
                    HStack {
                        TextField(key, text: $variables[key])
                            .textFieldStyle(.roundedBorder)
                        
                        Spacer()
                        
                        Button(action: {
                            variables[key] = ""
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .navigationTitle("Переменные")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .trailing) {
                    Button("ОК") {
                        onDismiss?()
                    }
                }
            }
        }
    }
}

#Preview {
    CsvBatchPrintSheet(
        count: .constant(1),
        onPrint: nil,
        onCancel: nil
    )
}
