import SwiftUI

/// Контролы для настройки параметров фигур
struct ShapeParamsControls: View {
    @Binding var params: ShapeParams
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Тип фигуры
            Text("Тип:")
                .font(.caption)
            Picker("Тип", selection: $params.type) {
                Text("Круг").tag(ShapeType.circle)
                Text("Прямоугольник").tag(ShapeType.rectangle)
                Text("Линия").tag(ShapeType.line)
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
                ), in: 10...200)
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
                ), in: 10...200)
                .frame(width: 150)
            }
            
            // Цвет
            Text("Цвет:")
                .font(.caption)
            HStack {
                Text(params.color)
                    .frame(width: 100)
                ColorPicker("", selection: Color(hex: params.color))
                    .frame(width: 150)
            }
            
            // Ширина линии
            if params.type != .line {
                Text("Ширина линии:")
                    .font(.caption)
                HStack {
                    Text("\(params.strokeWidth)")
                        .frame(width: 50, alignment: .trailing)
                    Slider(value: Binding(
                        get: { Double(params.strokeWidth) },
                        set: { params.strokeWidth = Int($0) }
                    ), in: 1...10)
                    .frame(width: 150)
                }
            }
        }
        .frame(width: 280)
    }
}

#Preview {
    ShapeParamsControls(params: .constant(ShapeParams()))
}
