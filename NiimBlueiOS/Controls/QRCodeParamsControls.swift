import SwiftUI

/// Контролы для настройки параметров QR-кода
struct QRCodeParamsControls: View {
    @Binding var params: QRCodeParams
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Данные
            Text("Данные:")
                .font(.caption)
            TextField("", text: $params.data, axis: .vertical)
                .textFieldStyle(.plain)
                .frame(height: 80)
            
            // Длина данных
            Text("Длина:")
                .font(.caption)
            HStack {
                Text("\(params.dataLength)")
                    .frame(width: 50, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.dataLength) },
                    set: { params.dataLength = Int($0) }
                ), in: 1...12)
                .frame(width: 150)
            }
            
            // Уровни коррекции ошибок
            Text("Коррекция ошибок:")
                .font(.caption)
            Picker("Коррекция", selection: $params.errorCorrectionLevel) {
                Text("Nизкая (L)").tag(ErrorCorrectionLevel.low)
                Text("Средняя (M)").tag(ErrorCorrectionLevel.medium)
                Text("Высокая (Q)").tag(ErrorCorrectionLevel.quarter)
                Text("Очень высокая (H)").tag(ErrorCorrectionLevel.high)
            }
            .pickerStyle(.menu)
            .frame(width: 200)
            
            // Размер модуля
            Text("Размер модуля:")
                .font(.caption)
            HStack {
                Text("\(params.moduleSize)")
                    .frame(width: 50, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.moduleSize) },
                    set: { params.moduleSize = Int($0) }
                ), in: 1...8)
                .frame(width: 150)
            }
        }
        .frame(width: 280)
    }
}

#Preview {
    QRCodeParamsControls(params: .constant(QRCodeParams()))
}
