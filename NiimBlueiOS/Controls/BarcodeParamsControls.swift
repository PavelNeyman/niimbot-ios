import SwiftUI

/// Контролы для настройки параметров штрих-кода
struct BarcodeParamsControls: View {
    @Binding var params: BarcodeParams
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Данные
            Text("Данные:")
                .font(.caption)
            TextField("", text: $params.data, axis: .vertical)
                .textFieldStyle(.plain)
                .frame(height: 80)
            
            // Тип штрих-кода
            Text("Тип:")
                .font(.caption)
            Picker("Тип", selection: $params.type) {
                ForEach(BarcodeType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 200)
            
            // Ширина
            Text("Ширина:")
                .font(.caption)
            HStack {
                Text("\(params.width)")
                    .frame(width: 50, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.width) },
                    set: { params.width = Int($0) }
                ), in: 50...200)
                .frame(width: 150)
            }
            
            // Высота
            Text("Высота:")
                .font(.caption)
            HStack {
                Text("\(params.height)")
                    .frame(width: 50, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.height) },
                    set: { params.height = Int($0) }
                ), in: 20...100)
                .frame(width: 150)
            }
            
            // Показать текст
            Toggle("Показать текст", isOn: $params.showText)
        }
        .frame(width: 280)
    }
}

#Preview {
    BarcodeParamsControls(params: .constant(BarcodeParams()))
}
