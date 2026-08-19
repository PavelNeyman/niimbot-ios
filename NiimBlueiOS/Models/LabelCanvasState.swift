import Foundation
import SwiftUI

/// Состояние canvas для редактора этикеток
class LabelCanvasState: ObservableObject {
    @Published var objects: [LabelObject] = []
    @Published var labelParams: LabelParams = LabelParams()
    
    // MARK: - Actions
    
    /// Добавить новый объект
    func addObject(type: ObjectType) {
        let newObject: LabelObject
        switch type {
        case .text:
            newObject = LabelObject(type: .text)
            if let params = newObject.textParams {
                newObject.textParams = params
            }
        case .qrcode:
            newObject = LabelObject(type: .qrcode)
        case .barcode:
            newObject = LabelObject(type: .barcode)
        case .image:
            newObject = LabelObject(type: .image)
        case .shape:
            newObject = LabelObject(type: .shape)
        }
        
        objects.append(newObject)
    }
    
    // MARK: - Update Text Params
    
    /// Обновить параметры текста
    func updateTextParams(for object: inout LabelObject, params: TextParams) {
        if object.type == .text {
            object.textParams = params
        }
    }
    
    /// Удалить объект по индексу
    func removeObject(at index: Int) {
        objects.remove(at: index)
    }
    
    /// Дублировать объект
    func duplicateObject(at index: Int) {
        guard index < objects.count else { return }
        let original = objects[index]
        let duplicate = original
        duplicate.id = UUID()
        objects.insert(duplicate, at: index + 1)
    }
    
    /// Переместить объект вверх
    func moveObjectUp(at index: Int) {
        guard index > 0 else { return }
        objects.swapAt(index - 1, index)
    }
    
    /// Переместить объект вниз
    func moveObjectDown(at index: Int) {
        guard index < objects.count - 1 else { return }
        objects.swapAt(index, index + 1)
    }
    
    /// Обновить параметры объекта
    func updateObject(at index: Int, params: Binding<LabelObject>) {
        guard index < objects.count else { return }
        withAnimation {
            objects[index] = params.wrappedValue
        }
    }
    
    /// Получить объект по индексу
    subscript(index: Int) -> LabelObject? {
        get { objects[index] }
        set { objects[index] = newValue ?? LabelObject() }
    }
    
    /// Получить количество объектов
    var count: Int {
        return objects.count
    }
}
