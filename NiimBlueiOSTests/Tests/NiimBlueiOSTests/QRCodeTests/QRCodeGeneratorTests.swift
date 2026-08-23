//
//  QRCodeGeneratorTests.swift
//  NiimBlueiOSTests
//
//  Тесты для QRCodeGenerator
//

import XCTest
@testable import NiimBlueiOS

final class QRCodeGeneratorTests: XCTestCase {
    
    let generator = QRCodeGenerator()
    
    // MARK: - Test QR Code Generation
    
    func testGenerateQRCodeWithText() {
        let text = "https://example.com"
        let result = generator.generateQRCode(text: text)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован")
    }
    
    func testGenerateQRCodeWithEmptyData() {
        let result = generator.generateQRCode(text: "")
        
        XCTAssertNil(result, description: "Пустой текст не должен генерировать QR-код")
    }
    
    func testGenerateQRCodeWithInvalidData() {
        let result = generator.generateQRCode(text: "Invalid@#$%")
        
        XCTAssertNil(result, description: "Некорректные данные не должны генерировать QR-код")
    }
    
    func testGenerateQRCodeWithSpecialCharacters() {
        let text = "Test with special chars: @#$%^&*()_+-=[]{}|;':\",./<>?"
        let result = generator.generateQRCode(text: text)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован для текста с спецсимволами")
    }
    
    func testGenerateQRCodeWithNumbers() {
        let text = "1234567890"
        let result = generator.generateQRCode(text: text)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован для цифр")
    }
    
    func testGenerateQRCodeWithUnicode() {
        let text = "Привет мир! 你好世界"
        let result = generator.generateQRCode(text: text)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован для Unicode")
    }
    
    func testGenerateQRCodeWithVeryLongText() {
        let text = "A".repeat(count: 1000)
        let result = generator.generateQRCode(text: text)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован для длинного текста")
    }
    
    // MARK: - Test Error Levels
    
    func testGenerateQRCodeWithLowErrorCorrection() {
        let result = generator.generateQRCode(text: "Test", errorCorrectionLevel: .low)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован с низким уровнем коррекции")
    }
    
    func testGenerateQRCodeWithMediumErrorCorrection() {
        let result = generator.generateQRCode(text: "Test", errorCorrectionLevel: .medium)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован со средним уровнем коррекции")
    }
    
    func testGenerateQRCodeWithHighErrorCorrection() {
        let result = generator.generateQRCode(text: "Test", errorCorrectionLevel: .quartile4)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован с высоким уровнем коррекции")
    }
    
    func testGenerateQRCodeWithVeryHighErrorCorrection() {
        let result = generator.generateQRCode(text: "Test", errorCorrectionLevel: .quartile3)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован с очень высоким уровнем коррекции")
    }
    
    // MARK: - Test Image Data
    
    func testGenerateQRCodeImageHasCorrectFormat() {
        let result = generator.generateQRCode(text: "Test")
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован")
        XCTAssertNotNil(result?.jpegData(compressionQuality: 1.0), 
                      description: "QR-код должен иметь JPEG данные")
    }
    
    func testGenerateQRCodeImageSize() {
        let result = generator.generateQRCode(text: "Test")
        
        guard let imageData = result?.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        XCTAssertGreaterThan(imageData.count, 0, 
                           description: "QR-код должен иметь размер больше 0 байт")
    }
    
    // MARK: - Test Edge Cases
    
    func testGenerateQRCodeWithEmptyString() {
        let result = generator.generateQRCode(text: "")
        
        XCTAssertNil(result, description: "Пустая строка не должна генерировать QR-код")
    }
    
    func testGenerateQRCodeWithNil() {
        XCTAssertThrowsError(try generator.generateQRCode(text: nil)) { error in
            XCTAssertNotNil(error, description: "Ничего не должно генерировать QR-код")
        }
    }
    
    func testGenerateQRCodeWithVeryLongData() {
        let longText = "A".repeat(count: 2000)
        let result = generator.generateQRCode(text: longText)
        
        XCTAssertNotNil(result, description: "QR-код должен быть сгенерирован для очень длинного текста")
    }
}

extension QRCodeGeneratorTests {
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
