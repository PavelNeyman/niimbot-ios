import SwiftUI

/// Редактор свойств этикетки
struct LabelPropsEditor: View {
    @Binding var params: LabelParams
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Ширина этикетки
            Text("Ширина этикетки:")
                .font(.caption)
            HStack {
                Text("\(params.width)")
                    .frame(width: 60, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.width) },
                    set: { params.width = Int($0) }
                ), in: 20...304)
                .frame(width: 150)
            }
            
            // Высота этикетки
            Text("Высота этикетки:")
                .font(.caption)
            HStack {
                Text("\(params.height)")
                    .frame(width: 60, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.height) },
                    set: { params.height = Int($0) }
                ), in: 20...304)
                .frame(width: 150)
            }
            
            // Единицы измерения
            Text("Единицы:")
                .font(.caption)
            Picker("Единицы", selection: $params.unit) {
                Text("мм").tag(LabelUnit.mm)
                Text("дюймы").tag(LabelUnit.inch)
            }
            .pickerStyle(.segmented)
            
            // Направление печати
            Text("Направление:")
                .font(.caption)
            Picker("Направление", selection: $params.printDirection) {
                Text("С лева направо").tag(PrintDirection.left)
                Text("С права налево").tag(PrintDirection.right)
            }
            .pickerStyle(.segmented)
            
            // Формат этикетки
            Text("Формат:")
                .font(.caption)
            Picker("Формат", selection: $params.shape) {
                Text("Прямоугольник").tag(LabelShape.rect)
                Text("Круг").tag(LabelShape.circle)
                Text("Овал").tag(LabelShape.oval)
            }
            .pickerStyle(.segmented)
            
            // Раскол этикетки
            Text("Раскол:")
                .font(.caption)
            Picker("Раскол", selection: $params.split) {
                Text("Нет").tag(LabelSplit.none)
                Text("Слева").tag(LabelSplit.left)
                Text("Справа").tag(LabelSplit.right)
                Text("Оба").tag(LabelSplit.both)
                Text("Сверху").tag(LabelSplit.top)
                Text("Снизу").tag(LabelSplit.bottom)
            }
            .pickerStyle(.segmented)
            
            // Позиция хвоста
            Text("Хвост:")
                .font(.caption)
            Picker("Хвост", selection: $params.tailPos) {
                Text("Нет").tag(TailPosition.none)
                Text("Слева").tag(TailPosition.left)
                Text("Справа").tag(TailPosition.right)
                Text("По центру").tag(TailPosition.center)
            }
            .pickerStyle(.segmented)
            
            // Отступы
            Text("Отступы:")
                .font(.caption)
            Picker("Отступы", selection: $params.margin) {
                Text("Авто").tag(LabelMargin.auto)
                Text("Нет").tag(LabelMargin.none)
                Text("Пользовательские").tag(LabelMargin.custom)
            }
            .pickerStyle(.segmented)
            
            // Плотность печати
            Text("Плотность:")
                .font(.caption)
            HStack {
                Text("\(params.density)")
                    .frame(width: 60, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.density) },
                    set: { params.density = Int($0) }
                ), in: 64...655)
                .frame(width: 150)
            }
            
            // Скорость печати
            Text("Скорость:")
                .font(.caption)
            HStack {
                Text("\(params.speed)")
                    .frame(width: 60, alignment: .trailing)
                Slider(value: Binding(
                    get: { Double(params.speed) },
                    set: { params.speed = Int($0) }
                ), in: 1...9)
                .frame(width: 150)
            }
        }
        .frame(width: 280)
    }
}

#Preview {
    LabelPropsEditor(params: .constant(LabelParams()))
}
