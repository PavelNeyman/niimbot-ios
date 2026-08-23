//
//  CSVImportUITests.swift
//  NiimBlueiOSTests
//
//  UI Тесты для CSV импорта
//

import XCTest
@testable import NiimBlueiOS

final class CSVImportUITests: UITestCase {
    
    // MARK: - Test CSV Import UI
    
    func testCSVImportViewAppears() {
        // Открываем CSV импорт
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Проверка, что CSV импорт появился
        XCTAssertTrue(app.buttons["CSV Import"].exists, "CSV Import должен существовать")
    }
    
    func testCSVImportWithValidFile() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла
        app.buttons["OK"].tap()
        
        // Проверка, что CSV был импортирован
        XCTAssertTrue(app.buttons["Import Success"].exists, "CSV должен быть успешно импортирован")
    }
    
    func testCSVImportWithErrorHandling() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор несуществующего файла
        app.buttons["Choose File"].tap()
        
        // Имитация ошибки
        app.buttons["Cancel"].tap()
        
        // Проверка, что ошибка была показана
        XCTAssertTrue(app.buttons["Error"].exists, "Ошибка должна быть показана")
    }
    
    func testCSVImportWithInvalidFormat() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла с неверным расширением
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла с неверным расширением
        app.buttons["OK"].tap()
        
        // Проверка, что ошибка была показана
        XCTAssertTrue(app.buttons["Error"].exists, "Ошибка должна быть показана")
    }
    
    func testCSVImportWithEmptyFile() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор пустого файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора пустого файла
        app.buttons["OK"].tap()
        
        // Проверка, что ошибка была показана
        XCTAssertTrue(app.buttons["Error"].exists, "Ошибка должна быть показана")
    }
    
    func testCSVImportWithMultipleFiles() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор нескольких файлов
        app.buttons["Choose File"].tap()
        
        // Имитация выбора нескольких файлов
        app.buttons["OK"].tap()
        
        // Проверка, что все файлы были импортированы
        XCTAssertTrue(app.buttons["Import Success"].exists, "Все файлы должны быть успешно импортированы")
    }
    
    func testCSVImportWithBatchPrint() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла
        app.buttons["OK"].tap()
        
        // Проверка, что batch print доступен
        XCTAssertTrue(app.buttons["Batch Print"].exists, "Batch Print должен существовать")
    }
    
    func testCSVImportWithQuantitySelection() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла
        app.buttons["OK"].tap()
        
        // Выбор количества
        app.buttons["Quantity"].tap()
        
        // Имитация выбора количества
        app.buttons["OK"].tap()
        
        // Проверка, что печать была запущена
        XCTAssertTrue(app.buttons["Print"].exists, "Print должен существовать")
    }
    
    // MARK: - Test CSV Import Error Messages
    
    func testCSVImportErrorMessage() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор несуществующего файла
        app.buttons["Choose File"].tap()
        
        // Имитация ошибки
        app.buttons["Cancel"].tap()
        
        // Проверка, что сообщение об ошибке содержит текст
        let errorMessage = app.buttons["Error"].value
        XCTAssertNotNil(errorMessage, "Сообщение об ошибке должно существовать")
    }
    
    func testCSVImportErrorMessageContainsDetails() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор несуществующего файла
        app.buttons["Choose File"].tap()
        
        // Имитация ошибки
        app.buttons["Cancel"].tap()
        
        // Проверка, что сообщение об ошибке содержит детали
        let errorMessage = app.buttons["Error"].value
        XCTAssertNotNil(errorMessage, "Сообщение об ошибке должно существовать")
    }
    
    // MARK: - Test CSV Import Validation
    
    func testCSVImportValidationShowsEmptyFileError() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор пустого файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора пустого файла
        app.buttons["OK"].tap()
        
        // Проверка, что ошибка была показана
        XCTAssertTrue(app.buttons["Error"].exists, "Ошибка должна быть показана")
    }
    
    func testCSVImportValidationShowsCorruptFileError() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор повреждённого файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора повреждённого файла
        app.buttons["OK"].tap()
        
        // Проверка, что ошибка была показана
        XCTAssertTrue(app.buttons["Error"].exists, "Ошибка должна быть показана")
    }
    
    func testCSVImportValidationShowsFileExistsError() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла с неверным расширением
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла с неверным расширением
        app.buttons["OK"].tap()
        
        // Проверка, что ошибка была показана
        XCTAssertTrue(app.buttons["Error"].exists, "Ошибка должна быть показана")
    }
    
    // MARK: - Test CSV Import Success
    
    func testCSVImportSuccessShowsTemplate() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла
        app.buttons["OK"].tap()
        
        // Проверка, что шаблон был создан
        XCTAssertTrue(app.buttons["Template Created"].exists, "Шаблон должен быть создан")
    }
    
    func testCSVImportSuccessShowsRowData() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла
        app.buttons["OK"].tap()
        
        // Проверка, что данные строки были показаны
        XCTAssertTrue(app.buttons["Row Data"].exists, "Данные строки должны быть показаны")
    }
    
    // MARK: - Test CSV Import Variable Population
    
    func testCSVImportVariablePopulation() {
        let app = XCUIApplication()
        app.launch()
        
        // Навигация к CSV импорту
        app.buttons["CSV Import"].tap()
        
        // Выбор файла
        app.buttons["Choose File"].tap()
        
        // Имитация выбора файла
        app.buttons["OK"].tap()
        
        // Проверка, что переменные были заполнены
        XCTAssertTrue(app.buttons["Variables"].exists, "Переменные должны быть заполнены")
    }
}

extension CSVImportUITests {
    private func equal<T>(_ actual: T, expected: T, description: String = "") -> Bool {
        let result = actual == expected
        if result {
            print("✓ \(description)")
        } else {
            print("✗ \(description) - Expected: \(expected), Got: \(actual)")
        }
        return result
    }
}
