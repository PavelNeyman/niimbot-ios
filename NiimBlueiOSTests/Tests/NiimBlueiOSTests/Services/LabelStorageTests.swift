import XCTest
@testable import NiimBlueiOS
import NiimBlueiOSTests

final class LabelStorageTests: NiimBlueIOSTests, XCTestCase {
    
    // MARK: - Test Case Setup
    
    override func setUp() {
        super.setUp()
        labelStorage = LabelStorage()
    }
    
    override func tearDown() {
        super.tearDown()
        // Очистка папки
        try? fileManager.removeItem(at: savedLabelsFolder)
    }
    
    var labelStorage: LabelStorage!
    
    // MARK: - Save Label Tests
    
    func testSaveLabel() {
        // Arrange
        let objects = [
            LabelObject(
                id: UUID(),
                type: .text,
                content: "Тест",
                x: 10,
                y: 10,
                params: LabelObject.TextParams(
                    content: "Тест",
                    fontSize: 16,
                    justify: .center
                )
            )
        ]
        let labelParams = LabelParams(
            width: 100,
            height: 100,
            unit: .mm
        )
        
        // Act
        let template = labelStorage.saveLabel(
            name: "Тестовая",
            objects: objects,
            labelParams: labelParams
        )
        
        // Assert
        XCTAssertEqual(template.name, "Тестовая")
        XCTAssertEqual(template.objects.count, 1)
    }
    
    func testSaveLabelCreatesFile() {
        // Arrange
        let objects = []
        let labelParams = LabelParams()
        
        // Act
        let template = labelStorage.saveLabel(
            name: "Тест",
            objects: objects,
            labelParams: labelParams
        )
        
        // Assert
        XCTAssertFalse(template.url.path.isEmpty)
    }
    
    // MARK: - Load Label Tests
    
    func testLoadLabelByExactName() {
        // Arrange
        let objects = []
        let labelParams = LabelParams()
        let template = labelStorage.saveLabel(
            name: "Тест",
            objects: objects,
            labelParams: labelParams
        )
        
        // Act
        let loaded = labelStorage.loadLabel(named: template.name)
        
        // Assert
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.name, template.name)
    }
    
    func testLoadLabelByPartialName() {
        // Arrange
        let objects = []
        let labelParams = LabelParams()
        let template = labelStorage.saveLabel(
            name: "Мой Тест",
            objects: objects,
            labelParams: labelParams
        )
        
        // Act
        let loaded = labelStorage.loadLabel(named: "Тест")
        
        // Assert
        XCTAssertNotNil(loaded)
    }
    
    func testLoadLabelReturnsNilIfNotFound() {
        // Arrange
        let objects = []
        let labelParams = LabelParams()
        
        // Act
        let loaded = labelStorage.loadLabel(named: "Не существует")
        
        // Assert
        XCTAssertNil(loaded)
    }
    
    // MARK: - Import Label Tests
    
    func testImportLabelFromJsonFile() {
        // Arrange
        let jsonData = """
        {
          "id": "test-import-id",
          "name": "Импортированная этикетка",
          "date": "2026-08-22T10:00:00Z",
          "objects": [
            {
              "id": "text-1",
              "type": "Text",
              "content": "Текст",
              "params": {
                "font": "System",
                "size": 16,
                "color": "#000000",
                "alignment": "center"
              }
            }
          ],
          "labelParams": {
            "units": "mm",
            "margin": 10,
            "labelSize": "Standard"
          }
        }
        """
        
        let fileURL = documentsDirectory.appendingPathComponent("TestImport.json")
        try? jsonData.write(to: fileURL, options: .atomicWrite)
        
        // Act
        let template = labelStorage.importLabel(from: fileURL)
        
        // Assert
        XCTAssertNotNil(template)
        XCTAssertEqual(template?.name, "Импортированная этикетка")
        XCTAssertEqual(template?.objects.count, 1)
    }
    
    func testImportLabelReturnsNilIfFileNotFound() {
        // Arrange
        let nonExistentURL = documentsDirectory.appendingPathComponent("NonExistent.json")
        
        // Act
        let template = labelStorage.importLabel(from: nonExistentURL)
        
        // Assert
        XCTAssertNil(template)
    }
    
    func testImportLabelReturnsNilIfInvalidJson() {
        // Arrange
        let invalidData = Data(["not", "valid", "json"].utf8)
        let fileURL = documentsDirectory.appendingPathComponent("Invalid.json")
        try? invalidData.write(to: fileURL, options: .atomicWrite)
        
        // Act
        let template = labelStorage.importLabel(from: fileURL)
        
        // Assert
        XCTAssertNil(template)
    }
    
    // MARK: - Delete Label Tests
    
    func testDeleteLabel() {
        // Arrange
        let objects = []
        let labelParams = LabelParams()
        let template = labelStorage.saveLabel(
            name: "Удалить",
            objects: objects,
            labelParams: labelParams
        )
        
        // Act
        let index = labelStorage.savedLabels.firstIndex(where: { $0.name == template.name }) ?? 0
        labelStorage.deleteLabel(at: index)
        
        // Assert
        XCTAssertEqual(labelStorage.savedLabels.count, 0)
        XCTAssertFalse(fileManager.fileExists(atPath: template.url.path))
    }
}
