import Foundation

/// Генератор ZPL кода
final class ZPLGenerator {
    
    // MARK: - Generate ZPL
    
    /// Сгенерировать ZPL код для этикетки
    static func generateZPL(
        template: ExportedLabelTemplate,
        params: PrintParams,
        objects: [LabelObject]? = nil
    ) -> String {
        let objectsToPrint = objects ?? template.objects
        
        var zpl = ""
        
        // Заголовок
        zpl += "^X1N\n"
        zpl += "^MT1\n"
        zpl += "^PW\(template.labelParams.width)\n"
        zpl += "^PH\(template.labelParams.height)\n"
        zpl += "^FS\n"
        zpl += "^BY2\n"
        zpl += "^JD\(template.labelParams.density)\n"
        zpl += "^LP\(template.labelParams.printDirection == .left ? "L" : "R")\n"
        zpl += "^DE\(template.labelParams.shape)\n"
        zpl += "^JL\(template.labelParams.split.rawValue)\n"
        zpl += "^LS\(template.labelParams.tailPos.rawValue)\n"
        zpl += "^BM\(template.labelParams.margin.rawValue)\n"
        
        // Генерируем объекты
        for object in objectsToPrint {
            zpl += generateObjectZPL(object)
        }
        
        // Конец документа
        zpl += "^RF\n"
        
        return zpl
    }
    
    /// Сгенерировать ZPL для одного объекта
    private static func generateObjectZPL(_ object: LabelObject) -> String {
        var zpl = ""
        
        switch object.type {
        case .text:
            if let textParams = object.textParams {
                zpl += generateTextZPL(object, textParams)
            }
            
        case .qrcode:
            if let qrcodeParams = object.qrCodeParams {
                zpl += generateQRCodeZPL(object, qrcodeParams)
            }
            
        case .barcode:
            if let barcodeParams = object.barcodeParams {
                zpl += generateBarcodeZPL(object, barcodeParams)
            }
            
        case .image:
            if let imageParams = object.imageParams {
                zpl += generateImageZPL(object, imageParams)
            }
            
        case .shape:
            if let shapeParams = object.shapeParams {
                zpl += generateShapeZPL(object, shapeParams)
            }
        }
        
        return zpl
    }
    
    // MARK: - Text Object
    
    private static func generateTextZPL(_ object: LabelObject, _ params: LabelObject.TextParams) -> String {
        var zpl = ""
        
        // Позиция
        zpl += "^X\(Int(object.x))\n"
        zpl += "^Y\(Int(object.y))\n"
        
        // Размер шрифта
        zpl += "^A\(params.fontSize)\n"
        
        // Выравнивание
        zpl += "^A\(textAlignToZPL(params.justify))\n"
        
        // Жирный курсив
        zpl += "^FN\(params.bold ? 1 : 0)\n"
        zpl += "^F\(params.italic ? 1 : 0)\n"
        
        // Текст
        zpl += "^A0N,BC,NA,\"\(escapeText(params.content))\"\n"
        
        return zpl
    }
    
    // MARK: - QR Code Object
    
    private static func generateQRCodeZPL(_ object: LabelObject, _ params: LabelObject.QRCodeParams) -> String {
        var zpl = ""
        
        // Позиция
        zpl += "^X\(Int(object.x))\n"
        zpl += "^Y\(Int(object.y))\n"
        
        // Уровень коррекции ошибок
        zpl += "^BY\(qrErrorCorrectionToZPL(params.errorCorrectionLevel))\n"
        
        // Данные
        zpl += "^BWO\(params.dataLength),\(params.moduleSize),\"\(escapeText(params.data))\"\n"
        
        return zpl
    }
    
    // MARK: - Barcode Object
    
    private static func generateBarcodeZPL(_ object: LabelObject, _ params: LabelObject.BarcodeParams) -> String {
        var zpl = ""
        
        // Позиция
        zpl += "^X\(Int(object.x))\n"
        zpl += "^Y\(Int(object.y))\n"
        
        // Тип штрихкода
        zpl += "^BY\(barcodeTypeToZPL(params.type))\n"
        
        // Ширина и высота
        zpl += "^BWX\(params.width),\(params.height)\n"
        
        // Показать текст
        zpl += "^BTO\(params.showText ? 1 : 0)\n"
        
        // Данные
        zpl += "^BTA,NA,\"\(escapeText(params.data))\"\n"
        
        return zpl
    }
    
    // MARK: - Image Object
    
    private static func generateImageZPL(_ object: LabelObject, _ params: LabelObject.ImageParams) -> String {
        var zpl = ""
        
        // Позиция
        zpl += "^X\(Int(object.x))\n"
        zpl += "^Y\(Int(object.y))\n"
        
        // Ширина и высота
        zpl += "^IMG\(params.width),\(params.height),1\n"
        
        // Источник изображения (placeholder)
        zpl += "^IMG\(params.source)\n"
        
        return zpl
    }
    
    // MARK: - Shape Object
    
    private static func generateShapeZPL(_ object: LabelObject, _ params: LabelObject.ShapeParams) -> String {
        var zpl = ""
        
        // Позиция
        zpl += "^X\(Int(object.x))\n"
        zpl += "^Y\(Int(object.y))\n"
        
        // Размер
        zpl += "^PW\(params.width)\n"
        zpl += "^PH\(params.height)\n"
        
        // Цвет
        zpl += "^BC\(colorToZPL(params.color))\n"
        
        // Ширина линии
        zpl += "^BLS\(params.strokeWidth)\n"
        
        return zpl
    }
    
    // MARK: - Helpers
    
    private static func fontFamilyToZPL(_ fontFamily: String) -> String {
        // Простая маппинг шрифтов
        switch fontFamily {
        case "monospace":
            return "M"
        default:
            return "S"
        }
    }
    
    private static func textAlignToZPL(_ align: LabelObject.TextParams.Justify) -> String {
        switch align {
        case .left:
            return "L"
        case .center:
            return "C"
        case .right:
            return "R"
        }
    }
    
    private static func qrErrorCorrectionToZPL(_ level: LabelObject.QRCodeParams.ErrorCorrectionLevel) -> String {
        switch level {
        case .low:
            return "1"
        case .medium:
            return "2"
        case .quartile:
            return "3"
        case .high:
            return "4"
        }
    }
    
    private static func barcodeTypeToZPL(_ type: LabelObject.BarcodeParams.Type) -> String {
        switch type {
        case .code128:
            return "2"
        case .code39:
            return "3"
        case .ean13:
            return "1"
        case .upc:
            return "10"
        }
    }
    
    private static func escapeText(_ text: String) -> String {
        var escaped = ""
        for char in text {
            switch char {
            case "\n":
                escaped += "\\n"
            case "\t":
                escaped += "\\t"
            case "\"":
                escaped += "\\\""
            default:
                escaped += String(char)
            }
        }
        return escaped
    }
    
    private static func colorToZPL(_ color: Color) -> String {
        // Конвертация цвета в ZPL формат (BGR)
        let red = Int(color.red * 255)
        let green = Int(color.green * 255)
        let blue = Int(color.blue * 255)
        return "\(red),\(green),\(blue)"
    }
}
