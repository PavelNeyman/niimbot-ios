import SwiftUI

/// Контролы для настройки параметров текста
struct TextParamsControls: View {
    @Binding var params: TextParams
    @Binding var x: Double
    @Binding var y: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Позиция
            HStack {
                Text("X:")
                    .frame(width: 40)
                TextField("X", value: $x, format: .number)
                    .textFieldStyle(.plain)
                    .frame(width: 60)
                Text("Y:")
                    .frame(width: 40)
                TextField("Y", value: $y, format: .number)
                    .textFieldStyle(.plain)
                    .frame(width: 60)
            }
            
            // Контент
            Text("Контент:")
                .font(.caption)
            TextField("", text: $params.content, axis: .vertical)
                .textFieldStyle(.plain)
                .frame(height: 80)
            
            // Шрифт
            Text("Шрифт:")
                .font(.caption)
            Picker("Шрифт", selection: FontFamily.allCases) {
                ForEach(FontFamily.allCases, id: \.self) { font in
                    Text(font.rawValue).tag(font)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 200)
            
            // Размер шрифта
            Text("Размер:")
                .font(.caption)
            HStack {
                Text("\(params.fontSize)")
                    .frame(width: 50, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.fontSize) },
                    set: { params.fontSize = Int($0) }
                ), in: 8...72)
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
            
            // Выравнивание
            Text("Выравнивание:")
                .font(.caption)
            HStack {
                Picker("Выравнивание", selection: $params.justify) {
                    Text("Слева").tag(JustifyAlignment.left)
                    Text("По центру").tag(JustifyAlignment.center)
                    Text("Справа").tag(JustifyAlignment.right)
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            
            // Жирный/Курсив
            HStack(spacing: 10) {
                Toggle("Жирный", isOn: $params.bold)
                Toggle("Курсив", isOn: $params.italic)
            }
        }
        .frame(width: 280)
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    TextParamsControls(
        params: .constant(TextParams()),
        x: .constant(10),
        y: .constant(10)
    )
}
