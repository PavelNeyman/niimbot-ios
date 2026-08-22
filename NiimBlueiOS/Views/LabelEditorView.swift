import SwiftUI
import Foundation

/// Основной редактор этикеток
struct LabelEditorView: View {
    @StateObject private var canvasState = LabelCanvasState()
    @StateObject private var fontManager = FontManager()
    @StateObject private var iconManager = IconManager()
    
    @State private var selectedObjectIndex: Int = -1
    @State private var selectedType: ObjectType = .text
    
    @State private var textContent: String = ""
    @State private var textFontSize: Int = 16
    @State private var textFontFamily: FontFamily = .arial
    @State private var textColor: String = "#000000"
    @State private var textJustify: JustifyAlignment = .left
    @State private var textBold: Bool = false
    @State private var textItalic: Bool = false
    @State private var textIcon: String = ""
    
    @State private var systemFontsLoaded = false
    @State private var systemIconsLoaded = false
    
    private let canvasWidth: Double = 100
    private let canvasHeight: Double = 50
    
    var body: some View {
        NavigationView {
            VStack {
                // Загрузка системных шрифтов и иконок
                .task {
                    // Загрузить системные шрифты
                    do {
                        try await fontManager.loadSystemFonts()
                    } catch {
                        print("Failed to load system fonts: \(error)")
                    }
                    
                    // Загрузить системные иконки
                    do {
                        try await iconManager.loadSystemIcons()
                    } catch {
                        print("Failed to load system icons: \(error)")
                    }
                    
                    // Загрузить кастомные шрифты
                    do {
                        try await fontManager.loadCustomFontsAsync()
                    } catch {
                        print("Failed to load custom fonts: \(error)")
                    }
                    
                    // Загрузить кастомные иконки
                    do {
                        try await iconManager.loadCustomIconsAsync()
                    } catch {
                        print("Failed to load custom icons: \(error)")
                    }
                    
                    systemFontsLoaded = true
                    systemIconsLoaded = true
                }
            }
            // Canvas для отображения объектов
            VStack {
                // Canvas для отображения объектов
                LabelCanvasView(
                    objects: canvasState.objects,
                    labelParams: canvasState.labelParams,
                    selectedObjectIndex: $selectedObjectIndex
                )
                .frame(width: canvasWidth, height: canvasHeight)
                .background(
                    Rectangle()
                        .fill(Color(.systemGray6))
                )
                .cornerRadius(4)
                
                // Toolbar для управления объектами
                LabelToolbar(
                    objects: canvasState.objects,
                    selectedObjectIndex: $selectedObjectIndex
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Панель выбора типа объекта
                VStack {
                    Text("Добавить объект:")
                        .font(.headline)
                    
                    ObjectPicker(selectedType: $selectedType)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(8)
                .shadow(radius: 2)
                
                 // Панель редактирования текста
                 if let object = canvasState.objects.first(where: { $0.type == .text }) {
                     if let params = object.textParams {
                         TextParamsControls(
                             params: Binding(
                                 get: { params },
                                 set: { object.textParams = $0 }
                             ),
                             x: Binding(
                                 get: { object.x },
                                 set: { object.x = $0 }
                             ),
                             y: Binding(
                                 get: { object.y },
                                 set: { object.y = $0 }
                             ),
                             fontManager: fontManager,
                             iconManager: iconManager,
                             systemFonts: fontManager.systemFonts
                         )
                         .padding()
                         .background(Color(.systemGroupedBackground))
                         .cornerRadius(8)
                         .shadow(radius: 2)
                     }
                 }
                
                // Кнопка свойств этикетки
                Button(action: {
                    if let params = canvasState.labelParams {
                        let sheet = NavigationView {
                            LabelPropsEditor(params: .constant(params))
                        }
                        .navigationTitle("Свойства этикетки")
                    }
                }) {
                    Image(systemName: "rectangle.and.paperclip")
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                }
                .disabled(canvasState.labelParams == nil)
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(8)
                .shadow(radius: 2)
            }
            .padding()
            .navigationTitle("Редактор этикеток")
            .sheet(item: $canvasState.labelParams) { params in
                NavigationView {
                    LabelPropsEditor(params: .constant(params))
                }
                .navigationTitle("Свойства этикетки")
            }
        }
    }
}

// MARK: - Label Canvas View

struct LabelCanvasView: View {
    let objects: [LabelObject]
    let labelParams: LabelParams
    @Binding var selectedObjectIndex: Int
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(objects.indices, id: \.self) { index in
                let object = objects[index]
                
                ZStack {
                    // Выделение объекта
                    if selectedObjectIndex == index {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue, lineWidth: 2)
                    }
                    
                    // Отрисовка объекта
                    ObjectPreviewView(object: object)
                        .onTapGesture {
                            withAnimation {
                                selectedObjectIndex = index
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(
                                    selectedObjectIndex == index
                                    ? Color.blue
                                    : Color.clear,
                                    lineWidth: 2
                                )
                                .onTapGesture {
                                    withAnimation {
                                        selectedObjectIndex = index
                                    }
                                }
                        )
                }
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 4)
    }
}

// MARK: - Object Preview View

struct ObjectPreviewView: View {
    let object: LabelObject
    
    var body: some View {
        switch object.type {
        case .text:
            TextPreviewView(object: object)
        case .qrcode:
            QRCodePreviewView(object: object)
        case .barcode:
            BarcodePreviewView(object: object)
        case .image:
            ImagePreviewView(object: object)
        case .shape:
            ShapePreviewView(object: object)
        }
    }
}

// MARK: - Text Preview

struct TextPreviewView: View {
    let object: LabelObject
    
    var body: some View {
        Text(object.textParams?.content ?? "")
            .font(.system(size: object.textParams?.fontSize ?? 16))
            .foregroundColor(Color(hex: object.textParams?.color ?? "#000000"))
            .bold(object.textParams?.bold ?? false)
            .italic(object.textParams?.italic ?? false)
    }
}

// MARK: - QR Code Preview

struct QRCodePreviewView: View {
    let object: LabelObject
    
    var body: some View {
        Text("QR Code")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

// MARK: - Barcode Preview

struct BarcodePreviewView: View {
    let object: LabelObject
    
    var body: some View {
        Text("Barcode")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

// MARK: - Image Preview

struct ImagePreviewView: View {
    let object: LabelObject
    
    var body: some View {
        Text("Image")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

// MARK: - Shape Preview

struct ShapePreviewView: View {
    let object: LabelObject
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: object.shapeParams?.color ?? "#000000"))
            .frame(width: object.width, height: object.height)
    }
}

// MARK: - Label Toolbar

struct LabelToolbar: View {
    let objects: [LabelObject]
    @Binding var selectedObjectIndex: Int
    
    var selectedObject: LabelObject? {
        guard selectedObjectIndex >= 0 && selectedObjectIndex < objects.count else { return nil }
        return objects[selectedObjectIndex]
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Кнопка удаления
            Button(action: {
                if !objects.isEmpty {
                    withAnimation {
                        selectedObjectIndex = -1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        canvasState.removeObject(at: selectedObjectIndex)
                    }
                }
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
            }
            .disabled(selectedObjectIndex < 0)
            
            // Кнопка дублирования
            Button(action: {
                if !objects.isEmpty {
                    canvasState.duplicateObject(at: selectedObjectIndex)
                }
            }) {
                Image(systemName: "copy")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
            }
            .disabled(selectedObjectIndex < 0)
            
            // Кнопка движения вверх
            Button(action: {
                if !objects.isEmpty && selectedObjectIndex > 0 {
                    canvasState.moveObjectUp(at: selectedObjectIndex)
                }
            }) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18))
                    .foregroundColor(.green)
            }
            .disabled(selectedObjectIndex <= 0)
            
            // Кнопка движения вниз
            Button(action: {
                if !objects.isEmpty && selectedObjectIndex < objects.count - 1 {
                    canvasState.moveObjectDown(at: selectedObjectIndex)
                }
            }) {
                Image(systemName: "arrow.down")
                    .font(.system(size: 18))
                    .foregroundColor(.green)
            }
            .disabled(selectedObjectIndex >= objects.count - 1)
            
            Spacer()
            
            // Информация об объекте
            if let object = selectedObject {
                Text("\(object.type.displayName) \(object.width)×\(object.height)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("Нет выбранного объекта")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Helper Functions

func Color(hex: String) -> Color {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // AAA
        a = 1
        r = int >> 8
        g = int >> 16
        b = int >> 24
    case 6: // RGB
        a = 1
        r = int >> 16
        g = int >> 8
        b = int
    case 8: // AARRGGBB
        a = int >> 24
        r = (int >> 16) & 0xFF
        g = (int >> 8) & 0xFF
        b = int & 0xFF
    default:
        a = 1
        r = 0
        g = 0
        b = 0
    }
    return .init(
        .sRGB,
        red: Double(r) / 255,
        green: Double(g) / 255,
        blue: Double(b) / 255,
        opacity: Double(a) / 255
    )
}

#Preview("Label Editor") {
    LabelEditorView()
}
