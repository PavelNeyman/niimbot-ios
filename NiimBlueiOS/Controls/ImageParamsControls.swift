import SwiftUI

/// Контролы для настройки параметров изображения
struct ImageParamsControls: View {
    @Binding var params: ImageParams
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Источник
            Text("Источник:")
                .font(.caption)
            TextField("", text: $params.source, axis: .vertical)
                .textFieldStyle(.plain)
                .frame(height: 60)
            
            // Ширина
            Text("Ширина:")
                .font(.caption)
            HStack {
                Text("\(params.width)")
                    .frame(width: 50, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.width) },
                    set: { params.width = Int($0) }
                ), in: 20...300)
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
                ), in: 20...300)
                .frame(width: 150)
            }
            
            // Соотношение сторон
            HStack {
                Text("Соотношение:")
                Picker("Соотношение", selection: Binding(
                    get: { params.width == params.height ? "square" : "rectangle" },
                    set: {
                        if $0 == "square" {
                            params.width = params.height
                        } else {
                            params.width = params.height * 1.5
                        }
                    }
                )) {
                    Text("Квадрат").tag("square")
                    Text("Пропорционально").tag("rectangle")
                }
                .pickerStyle(.segmented)
            }
        }
        .frame(width: 280)
    }
}

#Preview {
    ImageParamsControls(params: .constant(ImageParams()))
}
