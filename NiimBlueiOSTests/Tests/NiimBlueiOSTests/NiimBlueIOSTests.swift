import XCTest
import NiimBlueiOS

/// Базовый класс для тестирования
class NiimBlueIOSTests {
    
    var fileManager: FileManager
    var documentsDirectory: URL
    
    override init() {
        fileManager = FileManager.default
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Создаем папки для тестов
        try? fileManager.createDirectory(
            at: documentsDirectory.appendingPathComponent("SavedLabels"),
            withIntermediateDirectories: true
        )
    }
}
