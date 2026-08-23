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
        
        // Создаем контекст для обработки с оптимизацией памяти
        // Используем значение bytesPerRow, которое не превышает размер изображения
        let bytesPerRow = min(pixelWidth * 4, Int(CGFloat(pixelWidth) * CGFloat(pixelHeight) * 4 / Int(pixelHeight)))
        guard let bitmapContext = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
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
        
        // Очищаем контекст для освобождения памяти
        bitmapContext.flush()
        
        return processedImage
    }
    
    /// Конвертировать CGImage в Data (PNG)
    static func convertToPNG(image: CGImage) -> Data? {
        guard let cgImage = image else { return nil }
        
        // Создаем изображение
        let cgImageRef = cgImage
        
        // Создаем контекст с оптимизацией памяти
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: min(cgImage.width * 4, Int(CGFloat(cgImage.width) * CGFloat(cgImage.height) * 4 / Int(cgImage.height))),
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
        
        // Очищаем контекст для освобождения памяти
        context.flush()
        
        // Конвертируем в PNG
        guard let data = processedImage.jpegData(compressionQuality: 0.85) else {
            return nil
        }
        
        return data
    }
}
