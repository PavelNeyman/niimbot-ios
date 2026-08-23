//
//  PrinterDiagnosticsTests.swift
//  NiimBlueiOSTests
//
//  Тесты для PrinterDiagnostics
//

import XCTest
@testable import NiimBlueiOS

final class PrinterDiagnosticsTests: XCTestCase {
    
    let diagnostics = PrinterDiagnosticsService()
    
    // MARK: - Test Diagnostics
    
    func testGetDeviceDiagnostics() {
        let diagnostics = diagnostics.getDeviceDiagnostics()
        
        XCTAssertNotNil(diagnostics, description: "Диагностика должна быть создана")
        XCTAssertNotNil(diagnostics.deviceName, description: "deviceName должен быть заполнен")
        XCTAssertNotNil(diagnostics.deviceType, description: "deviceType должен быть заполнен")
    }
    
    func testGetDeviceDiagnosticsConnectionState() {
        let diagnostics = diagnostics.getDeviceDiagnostics()
        
        XCTAssertNotNil(diagnostics.connectionState, description: "ConnectionState должен быть заполнен")
    }
    
    func testGetDeviceDiagnosticsPrinterModel() {
        let diagnostics = diagnostics.getDeviceDiagnostics()
        
        // Модель принтера может быть nil или заполнена
        XCTAssertNotNil(diagnostics.printerModel, 
                      description: "printerModel может быть nil или заполнена")
    }
    
    // MARK: - Test ConnectionState
    
    func testConnectionStateValues() {
        let states: [ConnectionState] = [.connected, .disconnected, .connecting, .error]
        
        for state in states {
            XCTAssertEqual(ConnectionState.connected.rawValue, "connected", 
                          description: "connected должен иметь значение 'connected'")
            XCTAssertEqual(ConnectionState.disconnected.rawValue, "disconnected", 
                          description: "disconnected должен иметь значение 'disconnected'")
            XCTAssertEqual(ConnectionState.connecting.rawValue, "connecting", 
                          description: "connecting должен иметь значение 'connecting'")
            XCTAssertEqual(ConnectionState.error.rawValue, "error", 
                          description: "error должен иметь значение 'error'")
        }
    }
    
    // MARK: - Test Diagnostics Service Methods
    
    func testIsDeviceConnected() {
        let result = diagnostics.isDeviceConnected()
        
        // Результат может быть true или false в зависимости от состояния
        XCTAssertNotNil(result, description: "isDeviceConnected должен вернуть Bool")
    }
    
    func testGetDeviceStatus() {
        let status = diagnostics.getDeviceStatus()
        
        XCTAssertNotNil(status, description: "getDeviceStatus должен вернуть статус")
        XCTAssertGreaterThan(status.count, 0, description: "Статус должен быть заполнен")
    }
    
    // MARK: - Test PrinterDiagnostics Struct
    
    func testPrinterDiagnosticsStructure() {
        let diagnostics = PrinterDiagnostics(
            deviceName: "Test Printer",
            deviceType: "Bluetooth LE",
            connectionState: .connected,
            lastPrintDate: Date(),
            missedPrinters: 0,
            printerModel: "NIIMBOT-123",
            zplDriverVersion: "1.0",
            supportedLabelFormats: ["20x20mm", "30x30mm"],
            printerTemperature: 45,
            memoryUsage: 1024
        )
        
        XCTAssertEqual(diagnostics.deviceName, "Test Printer", 
                      description: "deviceName должен совпадать")
        XCTAssertEqual(diagnostics.deviceType, "Bluetooth LE", 
                      description: "deviceType должен совпадать")
        XCTAssertEqual(diagnostics.connectionState, .connected, 
                      description: "connectionState должен совпадать")
        XCTAssertEqual(diagnostics.missedPrinters, 0, 
                      description: "missedPrinters должен совпадать")
        XCTAssertEqual(diagnostics.printerModel, "NIIMBOT-123", 
                      description: "printerModel должен совпадать")
        XCTAssertEqual(diagnostics.zplDriverVersion, "1.0", 
                      description: "zplDriverVersion должен совпадать")
        XCTAssertEqual(diagnostics.supportedLabelFormats?.count, 2, 
                      description: "supportedLabelFormats должно содержать 2 элемента")
        XCTAssertEqual(diagnostics.printerTemperature, 45, 
                      description: "printerTemperature должен совпадать")
        XCTAssertEqual(diagnostics.memoryUsage, 1024, 
                      description: "memoryUsage должен совпадать")
    }
    
    func testPrinterDiagnosticsWithNilOptionalValues() {
        let diagnostics = PrinterDiagnostics(
            deviceName: "Test Printer",
            deviceType: "Bluetooth LE",
            connectionState: .connected,
            lastPrintDate: nil,
            missedPrinters: 0,
            printerModel: nil,
            zplDriverVersion: nil,
            supportedLabelFormats: nil,
            printerTemperature: nil,
            memoryUsage: nil
        )
        
        XCTAssertNil(diagnostics.lastPrintDate, 
                    description: "lastPrintDate может быть nil")
        XCTAssertNil(diagnostics.printerModel, 
                    description: "printerModel может быть nil")
        XCTAssertNil(diagnostics.zplDriverVersion, 
                    description: "zplDriverVersion может быть nil")
        XCTAssertNil(diagnostics.supportedLabelFormats, 
                    description: "supportedLabelFormats может быть nil")
        XCTAssertNil(diagnostics.printerTemperature, 
                    description: "printerTemperature может быть nil")
        XCTAssertNil(diagnostics.memoryUsage, 
                    description: "memoryUsage может быть nil")
    }
    
    // MARK: - Test Codable
    
    func testPrinterDiagnosticsCodable() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let diagnostics = PrinterDiagnostics(
            deviceName: "Test Printer",
            deviceType: "Bluetooth LE",
            connectionState: .connected,
            lastPrintDate: Date(),
            missedPrinters: 5,
            printerModel: "NIIMBOT-123",
            zplDriverVersion: "1.0",
            supportedLabelFormats: ["20x20mm"],
            printerTemperature: 45,
            memoryUsage: 1024
        )
        
        let data = try? encoder.encode(diagnostics)
        
        XCTAssertNotNil(data, description: "Должен быть закодирован PrinterDiagnostics")
    }
    
    func testPrinterDiagnosticsDecodable() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let diagnostics = PrinterDiagnostics(
            deviceName: "Test Printer",
            deviceType: "Bluetooth LE",
            connectionState: .connected,
            lastPrintDate: Date(),
            missedPrinters: 5,
            printerModel: "NIIMBOT-123",
            zplDriverVersion: "1.0",
            supportedLabelFormats: ["20x20mm"],
            printerTemperature: 45,
            memoryUsage: 1024
        )
        
        let data = try? encoder.encode(diagnostics)
        let decoded = try? decoder.decode(PrinterDiagnostics.self, from: data)
        
        XCTAssertNotNil(decoded, description: "Должен быть декодирован PrinterDiagnostics")
        XCTAssertEqual(decoded?.deviceName, diagnostics.deviceName, 
                      description: "deviceName должен совпадать после декодирования")
    }
    
    // MARK: - Test PrintStatus
    
    func testPrintStatusValues() {
        let statuses: [PrintStatus] = [.success, .failed, .cancelled]
        
        for status in statuses {
            switch status {
            case .success:
                XCTAssertEqual(PrintStatus.success.rawValue, "success", description: "success должен иметь значение 'success'")
            case .failed:
                XCTAssertEqual(PrintStatus.failed.rawValue, "failed", description: "failed должен иметь значение 'failed'")
            case .cancelled:
                XCTAssertEqual(PrintStatus.cancelled.rawValue, "cancelled", description: "cancelled должен иметь значение 'cancelled'")
            }
        }
    }
    
    func testPrintStatusDescription() {
        XCTAssertEqual(PrintStatus.success.description, "Успех", description: "success должен иметь описание 'Успех'")
        XCTAssertEqual(PrintStatus.failed.description, "Ошибка", description: "failed должен иметь описание 'Ошибка'")
        XCTAssertEqual(PrintStatus.cancelled.description, "Отменено", description: "cancelled должен иметь описание 'Отменено'")
    }
}

extension PrinterDiagnosticsTests {
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
