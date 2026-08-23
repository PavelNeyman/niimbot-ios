//
//  PrintHistoryServiceTests.swift
//  NiimBlueiOSTests
//
//  Тесты для PrintHistoryService
//

import XCTest
@testable import NiimBlueiOS

final class PrintHistoryServiceTests: XCTestCase {
    
    var service: PrintHistoryService!
    var testDate: Date!
    
    override func setUp() {
        super.setUp()
        service = PrintHistoryService()
        testDate = Date()
    }
    
    override func tearDown() {
        service = nil
        testDate = nil
        super.tearDown()
    }
    
    // MARK: - Test Add Entry
    
    func testAddEntry() {
        let entry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Test Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        service.addEntry(entry)
        
        XCTAssertEqual(service.entries.count, 1, description: "Должно быть 1 запись")
        XCTAssertEqual(service.entries[0].labelName, "Test Label", description: "Название должно совпадать")
    }
    
    func testAddMultipleEntries() {
        let entries: [PrintHistoryEntry] = (1...5).map { i in
            PrintHistoryEntry(
                id: UUID(),
                labelName: "Label \(i)",
                printDate: testDate,
                printDuration: Double(i),
                quantity: i,
                connectionType: .bluetooth,
                printerType: .bluetooth,
                status: .success
            )
        }
        
        entries.forEach { service.addEntry($0) }
        
        XCTAssertEqual(service.entries.count, 5, description: "Должно быть 5 записей")
    }
    
    // MARK: - Test Remove Entry
    
    func testRemoveEntry() {
        let entry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Test Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        service.addEntry(entry)
        
        XCTAssertEqual(service.entries.count, 1, description: "Должно быть 1 запись")
        
        service.removeEntry(entry)
        
        XCTAssertEqual(service.entries.count, 0, description: "Должно быть 0 записей")
    }
    
    func testRemoveEntryById() {
        let entry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Test Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        service.addEntry(entry)
        
        service.removeEntryById(entry.id)
        
        XCTAssertEqual(service.entries.count, 0, description: "Должно быть 0 записей")
    }
    
    // MARK: - Test Clear History
    
    func testClearHistory() {
        let entries: [PrintHistoryEntry] = (1...10).map { i in
            PrintHistoryEntry(
                id: UUID(),
                labelName: "Label \(i)",
                printDate: testDate,
                printDuration: Double(i),
                quantity: i,
                connectionType: .bluetooth,
                printerType: .bluetooth,
                status: .success
            )
        }
        
        entries.forEach { service.addEntry($0) }
        
        XCTAssertEqual(service.entries.count, 10, description: "Должно быть 10 записей")
        
        service.clearHistory()
        
        XCTAssertEqual(service.entries.count, 0, description: "Должно быть 0 записей")
    }
    
    // MARK: - Test Filter by Date
    
    func testFilterByDate() {
        let futureDate = testDate.addingTimeInterval(3600)
        
        let entries: [PrintHistoryEntry] = (1...5).map { i in
            PrintHistoryEntry(
                id: UUID(),
                labelName: "Label \(i)",
                printDate: testDate,
                printDuration: Double(i),
                quantity: i,
                connectionType: .bluetooth,
                printerType: .bluetooth,
                status: .success
            )
        }
        
        entries.forEach { service.addEntry($0) }
        
        let filtered = service.filterByDate(after: futureDate)
        
        XCTAssertEqual(filtered.count, 0, description: "После даты должно быть 0 записей")
    }
    
    // MARK: - Test Filter by Status
    
    func testFilterByStatus() {
        let successEntry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Success Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        let failedEntry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Failed Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .failed
        )
        
        service.addEntry(successEntry)
        service.addEntry(failedEntry)
        
        let filtered = service.filterByStatus(.success)
        
        XCTAssertEqual(filtered.count, 1, description: "Должно быть 1 запись со статусом success")
    }
    
    // MARK: - Test Filter by Connection Type
    
    func testFilterByConnectionType() {
        let bluetoothEntry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Bluetooth Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        let usbEntry = PrintHistoryEntry(
            id: UUID(),
            labelName: "USB Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .usb,
            printerType: .usb,
            status: .success
        )
        
        service.addEntry(bluetoothEntry)
        service.addEntry(usbEntry)
        
        let filtered = service.filterByConnectionType(.bluetooth)
        
        XCTAssertEqual(filtered.count, 1, description: "Должно быть 1 запись с Bluetooth")
    }
    
    // MARK: - Test Last N Entries
    
    func testLastNEntries() {
        let entries: [PrintHistoryEntry] = (1...10).map { i in
            PrintHistoryEntry(
                id: UUID(),
                labelName: "Label \(i)",
                printDate: testDate,
                printDuration: Double(i),
                quantity: i,
                connectionType: .bluetooth,
                printerType: .bluetooth,
                status: .success
            )
        }
        
        entries.forEach { service.addEntry($0) }
        
        let last3 = service.lastN(3)
        
        XCTAssertEqual(last3.count, 3, description: "Должно быть 3 записи")
        XCTAssertEqual(last3[0].labelName, "Label 8", description: "Первая запись должна быть 8")
        XCTAssertEqual(last3[2].labelName, "Label 10", description: "Последняя запись должна быть 10")
    }
    
    // MARK: - Test Get Statistics
    
    func testGetStatistics() {
        let successEntry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Success Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        let failedEntry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Failed Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 3,
            connectionType: .usb,
            printerType: .usb,
            status: .failed
        )
        
        service.addEntry(successEntry)
        service.addEntry(failedEntry)
        
        let stats = service.getStatistics()
        
        XCTAssertEqual(stats.totalPrints, 2, description: "Всего печати должно быть 2")
        XCTAssertEqual(stats.successfulPrints, 1, description: "Успешных должно быть 1")
        XCTAssertEqual(stats.failedPrints, 1, description: "Ошибок должно быть 1")
        XCTAssertEqual(stats.totalQuantity, 8, description: "Всего quantity должно быть 8")
        XCTAssertEqual(stats.lastPrintDate, testDate, description: "Last print date должен быть testDate")
        XCTAssertEqual(stats.lastPrinterType, .usb, description: "Last printer type должен быть .usb")
        XCTAssertEqual(stats.lastConnectionType, .usb, description: "Last connection type должен быть .usb")
    }
    
    // MARK: - Test Save and Load History
    
    func testSaveAndLoadHistory() {
        let entry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Test Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        service.addEntry(entry)
        
        // Сохраняем и загружаем
        service.saveHistory()
        service.loadHistory()
        
        XCTAssertEqual(service.entries.count, 1, description: "Должно быть 1 запись после перезагрузки")
        XCTAssertEqual(service.entries[0].labelName, "Test Label", description: "Название должно совпадать")
    }
    
    // MARK: - Test IsPrintSuccess
    
    func testIsPrintSuccess() {
        let entry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Success Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        XCTAssert(service.isPrintSuccess(entry), description: "Success должен быть true")
        
        let failedEntry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Failed Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .failed
        )
        
        XCTAssert(!service.isPrintSuccess(failedEntry), description: "Failed должен быть false")
    }
    
    // MARK: - Test PrintHistoryEntry
    
    func testPrintHistoryEntryStructure() {
        let entry = PrintHistoryEntry(
            id: UUID(),
            labelName: "Test Label",
            printDate: testDate,
            printDuration: 10.0,
            quantity: 5,
            connectionType: .bluetooth,
            printerType: .bluetooth,
            status: .success
        )
        
        XCTAssertEqual(entry.labelName, "Test Label", description: "labelName должен совпадать")
        XCTAssertEqual(entry.printDate, testDate, description: "printDate должен совпадать")
        XCTAssertEqual(entry.printDuration, 10.0, description: "printDuration должен совпадать")
        XCTAssertEqual(entry.quantity, 5, description: "quantity должен совпадать")
        XCTAssertEqual(entry.connectionType, .bluetooth, description: "connectionType должен совпадать")
        XCTAssertEqual(entry.printerType, .bluetooth, description: "printerType должен совпадать")
        XCTAssertEqual(entry.status, .success, description: "status должен совпадать")
    }
}

extension PrintHistoryServiceTests {
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
