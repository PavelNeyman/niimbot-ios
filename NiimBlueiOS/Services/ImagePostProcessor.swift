import Foundation
import CoreGraphics

/// Пост-процессор изображений для печати
final class ImagePostProcessor {
    
    // MARK: - Public Methods
    
    /// Обработать изображение для печати
    /// - Parameters:
    ///   - image: Исходное изображение
    ///   - width: Ширина изображения в пикселях
    ///   - height: Высота изображения в пикселях
    ///   - density: Плотность печати
    /// - Returns: Обработанное изображение
    static func processImage(
        image: CGImage,
        width: Int,
        height: Int,
        density: Int = 256
    ) -> CGImage? {
        guard let cgImage = image else { return nil }
        
        // Получаем размеры изображения
        let pixelWidth = width
        let pixelHeight = height
        
        // Получаем цветовой пространство
        guard let colorSpace = cgImage.colorSpace else {
            return cgImage
        }
        
        // Создаем контекст для обработки
        guard let bitmapContext = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: pixelWidth * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return cgImage
        }
        
        // Масштабируем изображение
        let scale = CGFloat(density) / 256.0
        let scaledWidth = Int(CGFloat(pixelWidth) * scale)
        let scaledHeight = Int(CGFloat(pixelHeight) * scale)
        
        // Масштабируем изображение
        bitmapContext.draw(
            cgImage,
            in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
        )
        
        // Получаем обработанное изображение
        guard let processedImage = bitmapContext.makeImage() else {
            return cgImage
        }
        
        return processedImage
    }
    
    /// Конвертировать CGImage в Data (PNG)
    static func convertToPNG(image: CGImage) -> Data? {
        guard let cgImage = image else { return nil }
        
        // Создаем изображение
        let cgImageRef = cgImage
        
        // Создаем контекст
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: cgImage.width * 4,
            space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        
        context.draw(cgImageRef, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        
        // Получаем изображение
        guard let processedImage = context.makeImage() else {
            return nil
        }
        
        // Конвертируем в PNG
        guard let data = processedImage.jpegData(compressionQuality: 0.85) else {
            return nil
        }
        
        return data
    }
}
