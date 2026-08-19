import Foundation

/// Генератор ZPL кода для печати на NIIMBOT принтерах
class ZPLGenerator {
    
    // MARK: - Constants
    
    private static let zplHeader = "^XA\n"
    private static let zplFooter = "^XZ\n"
    private static let defaultDensity = "256"
    private static let defaultSpeed = "5"
    private static let defaultMemoryMode = "2"
    
    // MARK: - Public Methods
    
    static func generate(label: PrinterInfo, objects: [LabelObject]) -> String {
        var zpl = zplHeader
        
        // Set memory mode
        zpl += "^DM\(defaultMemoryMode)\n"
        
        // Set density
        zpl += "^LD\(defaultDensity)\n"
        
        // Set speed
        zpl += "^MS\(defaultSpeed)\n"
        
        // Generate label
        zpl += generateLabel(label: label, objects: objects)
        
        zpl += zplFooter
        
        return zpl
    }
    
    private static func generateLabel(label: PrinterInfo, objects: [LabelObject]) -> String {
        var zpl = ""
        
        // Set paper width and height
        zpl += "^PW\(label.capabilities["width"] ?? "203")\n"
        zpl += "^PH\(label.capabilities["height"] ?? "100")\n"
        
        // Generate objects
        for object in objects {
            zpl += generateObjectZPL(object: object)
        }
        
        return zpl
    }
    
    private static func generateObjectZPL(object: LabelObject) -> String {
        var zpl = ""
        
        switch object.type {
        case .text(let textParams):
            zpl += generateTextZPL(textParams: textParams)
        case .qrcode(let qrParams):
            zpl += generateQRCodeZPL(qrParams: qrParams)
        case .barcode(let barcodeParams):
            zpl += generateBarcodeZPL(barcodeParams: barcodeParams)
        case .image(let imageParams):
            zpl += generateImageZPL(imageParams: imageParams)
        case .shape(let shapeParams):
            zpl += generateShapeZPL(shapeParams: shapeParams)
        }
        
        return zpl
    }
    
    // MARK: - Text Generation
    
    private static func generateTextZPL(textParams: TextParams) -> String {
        var zpl = ""
        
        // Position
        zpl += "^FS\(textParams.x, \(textParams.y))\n"
        
        // Font
        zpl += "^A\(textParams.fontFamily)\n"
        
        // Size
        zpl += "^F\(textParams.fontSize)\n"
        
        // Justify
        zpl += "^JD\(textParams.justify)\n"
        
        // Content
        zpl += "\"\(textParams.content)\""
        
        return zpl
    }
    
    // MARK: - QR Code Generation
    
    private static func generateQRCodeZPL(qrParams: QRCodeParams) -> String {
        var zpl = ""
        
        // Position
        zpl += "^FS\(qrParams.x, \(qrParams.y))\n"
        
        // QR Code
        zpl += "^BQN\(qrParams.dataLength),\(qrParams.errorCorrectionLevel),\(qrParams.moduleSize)QR\(qrParams.data)N"
        
        return zpl
    }
    
    // MARK: - Barcode Generation
    
    private static func generateBarcodeZPL(barcodeParams: BarcodeParams) -> String {
        var zpl = ""
        
        // Position
        zpl += "^FS\(barcodeParams.x, \(barcodeParams.y))\n"
        
        // Barcode
        zpl += "^B\(barcodeParams.type.rawValue)\(barcodeParams.width),\(barcodeParams.height)\"\(barcodeParams.data)\""
        
        return zpl
    }
    
    // MARK: - Image Generation
    
    private static func generateImageZPL(imageParams: ImageParams) -> String {
        var zpl = ""
        
        // Position
        zpl += "^FS\(imageParams.x, \(imageParams.y))\n"
        
        // Image
        // Note: Actual image data should be embedded here
        // For now, using placeholder
        
        return zpl
    }
    
    // MARK: - Shape Generation
    
    private static func generateShapeZPL(shapeParams: ShapeParams) -> String {
        var zpl = ""
        
        // Position
        zpl += "^FS\(shapeParams.x, \(shapeParams.y))\n"
        
        // Shape
        switch shapeParams.type {
        case .circle:
            zpl += "^GD\(shapeParams.width),\(shapeParams.height)O"
        case .rectangle:
            zpl += "^GD\(shapeParams.width),\(shapeParams.height)R"
        case .line:
            zpl += "^GD\(shapeParams.width),\(shapeParams.height)L"
        }
        
        return zpl
    }
    
    // MARK: - Utility Methods
    
    static func escapeZPLString(_ string: String) -> String {
        var escaped = string
        escaped = escaped.replacingOccurrences(of: "\\", with: "\\\\")
        escaped = escaped.replacingOccurrences(of: "\"", with: "\\\"")
        escaped = escaped.replacingOccurrences(of: "\n", with: "\\n")
        escaped = escaped.replacingOccurrences(of: "\r", with: "\\r")
        escaped = escaped.replacingOccurrences(of: "\t", with: "\\t")
        
        return escaped
    }
    
    static func validateZPL(_ zpl: String) -> (isValid: Bool, message: String) {
        if !zpl.hasPrefix("^XA") || !zpl.hasSuffix("^XZ") {
            return (false, "ZPL должен начинаться с ^XA и заканчиваться с ^XZ")
        }
        
        return (true, "ZPL валиден")
    }
}
