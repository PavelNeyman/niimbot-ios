//
//  CSVTests.swift
//  NiimBlueiOSTests
//
//  Тесты для CsvParser и CsvParams
//

import XCTest
@testable import NiimBlueiOS

final class CSVTests: XCTestCase {
    
    var parser: CsvParser!
    var testFilePath: String!
    
    override func setUp() {
        super.setUp()
        parser = CsvParser()
        testFilePath = "/Users/pneyman/dev/personal/niimbot-ios/NiimBlueiOS/Resources/TestData/test_import.csv"
    }
    
    override func tearDown() {
        parser = nil
        testFilePath = nil
        super.tearDown()
    }
    
    // MARK: - Test CSV Parsing
    
    func testParseValidCSV() {
        let result = parser.parse(filePath: testFilePath)
        
        XCTAssert(true, equal: result.success, description: "CSV должен быть успешно распарсен")
        XCTAssertNotNil(result.params, description: "Параметры CSV должны быть не nil")
        
        let params = result.params!
        
        XCTAssertEqual(params.fileName, "test_import.csv", description: "Имя файла должно совпадать")
        XCTAssertEqual(params.headers.count, 4, description: "Заголовки должны содержать 4 элемента")
        XCTAssertEqual(params.rowCount, 4, description: "Должно быть 4 строки данных")
        XCTAssertEqual(params.columnCount, 4, description: "Должно быть 4 колонки")
        
        // Проверка данных
        XCTAssertEqual(params.getData(row: 0, column: 0), "1", description: "Значение ID строки 0, колонка 0")
        XCTAssertEqual(params.getData(row: 0, column: 1), "Product A", description: "Значение Name строки 0, колонка 1")
        XCTAssertEqual(params.getData(row: 1, column: 2), "test2@example.com", description: "Значение Email строки 1, колонка 2")
    }
    
    func testParseCSVWithHeaders() {
        let testCSV = """
        ID,Name,Email
        1,Test Product,test@example.com
        2,Another Product,another@example.com
        """
        
        let result = parser.parse(csv: testCSV)
        
        XCTAssert(true, equal: result.success, description: "CSV с заголовками должен быть распарсен")
        XCTAssertNotNil(result.params, description: "Параметры должны быть созданы")
        
        let params = result.params!
        XCTAssertEqual(params.headers.count, 2, description: "Должны быть 2 заголовка")
        XCTAssertEqual(params.rowCount, 1, description: "Должна быть 1 строка данных")
    }
    
    // MARK: - Test Error Cases
    
    func testParseEmptyCSV() {
        let result = parser.parse(csv: "")
        
        XCTAssert(false, equal: result.success, description: "Пустой CSV должен быть распарсен с ошибкой")
        XCTAssertNotNil(result.error, description: "Должно быть сообщение об ошибке")
    }
    
    func testParseInvalidCSV() {
        let result = parser.parse(csv: "This is not a CSV file")
        
        XCTAssert(false, equal: result.success, description: "Некорректный CSV должен быть распарсен с ошибкой")
        XCTAssertNotNil(result.error, description: "Должно быть сообщение об ошибке")
    }
    
    func testParseEmptyFile() {
        let result = parser.parse(filePath: "/Users/pneyman/dev/personal/niimbot-ios/NiimBlueiOS/Resources/TestData/empty.csv")
        
        XCTAssert(false, equal: result.success, description: "Пустой файл должен быть распарсен с ошибкой")
        XCTAssertNotNil(result.error, description: "Должно быть сообщение об ошибке")
    }
    
    func testParseNonExistentFile() {
        let result = parser.parse(filePath: "/nonexistent/file.csv")
        
        XCTAssert(false, equal: result.success, description: "Не существующий файл должен быть распарсен с ошибкой")
        XCTAssertNotNil(result.error, description: "Должно быть сообщение об ошибке")
    }
    
    // MARK: - Test Variable Access
    
    func testGetDataForRow() {
        let result = parser.parse(filePath: testFilePath)
        let params = result.params!
        
        let rowData = params.getDataForRow(row: 0)
        XCTAssertEqual(rowData?.count, 4, description: "Строка 0 должна содержать 4 элемента")
        XCTAssertEqual(rowData?[0], "1", description: "Первый элемент строки")
        XCTAssertEqual(rowData?[3], "10", description: "Последний элемент строки")
        
        let emptyRow = params.getDataForRow(row: 100)
        XCTAssertNil(emptyRow, description: "Существующая строка 100 не должна быть найдена")
    }
    
    func testColumnCount() {
        let result = parser.parse(csv: """
        ID,Name,Email,Quantity
        1,Test,test@example.com,10
        """)
        let params = result.params!
        
        XCTAssertEqual(params.columnCount, 4, description: "Должно быть 4 колонки")
    }
    
    func testRowCount() {
        let result = parser.parse(csv: """
        ID,Name
        1,Test
        2,Another
        """)
        let params = result.params!
        
        XCTAssertEqual(params.rowCount, 1, description: "Должна быть 1 строка данных")
    }
}

extension CSVTests {
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
