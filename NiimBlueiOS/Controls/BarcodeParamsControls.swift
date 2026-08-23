import SwiftUI

/// Контролы для настройки параметров штрих-кода
struct BarcodeParamsControls: View {
    @Binding var params: BarcodeParams
    @Binding var showPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Данные
            Text("Данные:")
                .font(.caption)
            TextField("", text: $params.data, axis: .vertical)
                .textFieldStyle(.plain)
                .frame(height: 80)
            
            // Тип штрих-кода
            BarcodeTypeSelector(
                selectedType: $params.type,
                showPicker: $showPicker,
                label: "Тип штрих-кода",
                showLabel: false
            )
            
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
    BarcodeParamsControls(
        params: .constant(BarcodeParams()),
        showPicker: .constant(true)
    )
}
