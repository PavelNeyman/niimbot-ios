//
//  QRCodeGenerator.swift
//  NiimBlueiOS
//
//  Сервис для генерации QR-кодов
//

import Foundation
import CoreGraphics
import UIKit

/// Генератор QR-кодов для этикеток
class QRCodeGenerator {
    
    /// Генерирует QR-код из текста
    /// - Parameters:
    ///   - text: Текст для кодирования
    ///   - errorCorrectionLevel: Уровень исправления ошибок
    /// - Returns: Data изображение QR-кода
    func generateQRCode(text: String, errorCorrectionLevel: QRCodeErrorCorrectionLevel = .medium) -> Data? {
        // Используем UIKit для генерации QR-кода
        let qrImage = generateQRCodeUsingUIKit(text: text, errorCorrectionLevel: errorCorrectionLevel)
        guard let data = qrImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        return data
    }
    
    /// Генерирует QR-код с помощью UIKit
    /// - Parameters:
    ///   - text: Текст для кодирования
    ///   - errorCorrectionLevel: Уровень исправления ошибок
    /// - Returns: UIImage QR-кода
    private func generateQRCodeUsingUIKit(text: String, errorCorrectionLevel: QRCodeErrorCorrectionLevel) -> UIImage? {
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        // Получаем генератор QR-кода
        let generator = QRCodeGenerator()
        let qr = generator.generate(data: data, errorCorrectionLevel: errorCorrectionLevel)
        
        // Преобразуем в UIImage
        guard let qrData = qr?.pngData() else {
            return nil
        }
        
        guard let image = UIImage(data: qrData) else {
            return nil
        }
        
        return image
    }
}

/// Уровень исправления ошибок QR-кода
enum QRCodeErrorCorrectionLevel {
    case low
    case medium
    case quartile3
    case quartile4
}

// MARK: - Extension for UIKit QR Code Generation

extension UIImage {
    func jpegData(compressionQuality: CGFloat) -> Data? {
        return jpegData(compressionQuality: compressionQuality)
    }
}
