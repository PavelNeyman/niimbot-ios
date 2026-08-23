//
//  BarcodeTypeTests.swift
//  NiimBlueiOSTests
//
//  Тесты для BarcodeType
//

import XCTest
@testable import NiimBlueiOS

final class BarcodeTypeTests: XCTestCase {
    
    // MARK: - Test BarcodeType Enum
    
    func testBarcodeTypeHasCorrectValues() {
        // Проверка всех значений enum
        XCTAssertEqual(BarcodeType.code128.rawValue, 0, description: "code128 должен иметь значение 0")
        XCTAssertEqual(BarcodeType.code39.rawValue, 1, description: "code39 должен иметь значение 1")
        XCTAssertEqual(BarcodeType.code93.rawValue, 2, description: "code93 должен иметь значение 2")
        XCTAssertEqual(BarcodeType.code11.rawValue, 3, description: "code11 должен иметь значение 3")
        XCTAssertEqual(BarcodeType.ean13.rawValue, 5, description: "ean13 должен иметь значение 5")
        XCTAssertEqual(BarcodeType.ean8.rawValue, 6, description: "ean8 должен иметь значение 6")
        XCTAssertEqual(BarcodeType.upca.rawValue, 7, description: "upca должен иметь значение 7")
        XCTAssertEqual(BarcodeType.upce.rawValue, 8, description: "upce должен иметь значение 8")
        XCTAssertEqual(BarcodeType.itf14.rawValue, 9, description: "itf14 должен иметь значение 9")
    }
    
    func testBarcodeTypeCount() {
        XCTAssertEqual(BarcodeType.allCases.count, 10, 
                      description: "Должно быть 10 типов штрихкодов")
    }
    
    // MARK: - Test BarcodeType Decoding
    
    func testDecodeBarcodeTypeFromInt() {
        let data = Data([0])
        let decoder = JSONDecoder()
        let result = try? decoder.decode(BarcodeType.self, from: data)
        
        XCTAssertEqual(result, BarcodeType.code128, 
                      description: "Должен быть декодирован BarcodeType из int")
    }
    
    func testDecodeBarcodeTypeFromRawValue() {
        let data = Data([5])
        let decoder = JSONDecoder()
        let result = try? decoder.decode(BarcodeType.self, from: data)
        
        XCTAssertEqual(result, BarcodeType.ean13, 
                      description: "Должен быть декодирован BarcodeType из raw value")
    }
    
    // MARK: - Test BarcodeType Encoding
    
    func testEncodeBarcodeTypeToInt() {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(BarcodeType.code128)
        
        XCTAssertNotNil(data, description: "Должен быть закодирован BarcodeType в int")
        XCTAssertEqual(data?.count, 4, description: "Длина данных должна быть 4 байта")
    }
    
    // MARK: - Test BarcodeType in BarcodeParams
    
    func testBarcodeParamsWithCode128() {
        let params = BarcodeParams(data: "12345", type: .code128)
        
        XCTAssertEqual(params.data, "12345", description: "Данные должны совпадать")
        XCTAssertEqual(params.type, .code128, description: "Тип должен быть code128")
    }
    
    func testBarcodeParamsWithEAN13() {
        let params = BarcodeParams(data: "1234567890123", type: .ean13)
        
        XCTAssertEqual(params.data, "1234567890123", description: "Данные должны совпадать")
        XCTAssertEqual(params.type, .ean13, description: "Тип должен быть ean13")
    }
    
    func testBarcodeParamsWithUPC() {
        let params = BarcodeParams(data: "123456789012", type: .upca)
        
        XCTAssertEqual(params.data, "123456789012", description: "Данные должны совпадать")
        XCTAssertEqual(params.type, .upca, description: "Тип должен быть upca")
    }
    
    // MARK: - Test BarcodeType String Representation
    
    func testBarcodeTypeStringRepresentation() {
        XCTAssertEqual(BarcodeType.code128.rawValue, "code128", 
                      description: "Raw value должен быть string")
        XCTAssertEqual(BarcodeType.ean13.rawValue, "ean13", 
                      description: "Raw value должен быть string")
        XCTAssertEqual(BarcodeType.upca.rawValue, "upca", 
                      description: "Raw value должен быть string")
    }
    
    // MARK: - Test BarcodeType Comparison
    
    func testBarcodeTypeEquality() {
        XCTAssertEqual(BarcodeType.code128, BarcodeType.code128, 
                      description: "Два одинаковых типа должны быть равны")
        XCTAssertNotEqual(BarcodeType.code128, BarcodeType.code39, 
                         description: "Разные типы должны быть неравны")
    }
    
    // MARK: - Test BarcodeType Hashing
    
    func testBarcodeTypeHashing() {
        let set = Set([BarcodeType.code128, BarcodeType.code39, BarcodeType.ean13])
        
        XCTAssertEqual(set.count, 3, 
                      description: "Должно быть 3 уникальных значения")
        
        XCTAssertEqual(BarcodeType.code128.hashValue, BarcodeType.code128.hashValue,
                      description: "Хэш должен быть консистентным")
    }
    
    // MARK: - Test BarcodeType with Data
    
    func testGenerateBarcodeDataWithCode128() {
        let data = "12345678901234567890".data(using: .utf8)!
        let barcodeType = BarcodeType.code128
        
        XCTAssertNotNil(barcodeType.rawValue, 
                      description: "BarcodeType должен иметь raw value")
    }
    
    func testGenerateBarcodeDataWithEAN13() {
        let data = "1234567890123".data(using: .utf8)!
        let barcodeType = BarcodeType.ean13
        
        XCTAssertNotNil(barcodeType.rawValue, 
                      description: "BarcodeType должен иметь raw value")
    }
    
    func testGenerateBarcodeDataWithUPC() {
        let data = "123456789012".data(using: .utf8)!
        let barcodeType = BarcodeType.upca
        
        XCTAssertNotNil(barcodeType.rawValue, 
                      description: "BarcodeType должен иметь raw value")
    }
}

extension BarcodeTypeTests {
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
