import Foundation

/// Объект на этикетке
enum ObjectType: String, Codable, CaseIterable {
    case text
    case qrcode
    case barcode
    case image
    case shape
    
    var displayName: String {
        switch self {
        case .text:
            return "Текст"
        case .qrcode:
            return "QR-код"
        case .barcode:
            return "Штрихкод"
        case .image:
            return "Изображение"
        case .shape:
            return "Фигура"
        }
    }
    
    var icon: String {
        switch self {
        case .text:
            return "textformat"
        case .qrcode:
            return "qrcode"
        case .barcode:
            return "barcode"
        case .image:
            return "photo"
        case .shape:
            return "square"
        }
    }
}

/// Общий интерфейс для всех объектов
struct LabelObject: Codable, Identifiable {
    let id: UUID
    var type: ObjectType
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    var rotation: Double
    
    // MARK: - Text Object
    
    struct TextParams: Codable {
        var content: String
        var fontSize: Int
        var fontFamily: String
        var color: String
        var justify: JustifyAlignment
        var bold: Bool
        var italic: Bool
        
        enum CodingKeys: String, CodingKey {
            case content, fontSize, fontFamily, color, justify, bold, italic
        }
    }
    
    // MARK: - QR Code Object
    
    struct QRCodeParams: Codable {
        var data: String
        var dataLength: Int
        var errorCorrectionLevel: ErrorCorrectionLevel
        var moduleSize: Int
        
        enum CodingKeys: String, CodingKey {
            case data, dataLength, errorCorrectionLevel, moduleSize
        }
    }
    
    // MARK: - Barcode Object
    
    struct BarcodeParams: Codable {
        var data: String
        var type: BarcodeType
        var width: Int
        var height: Int
        var showText: Bool
        
        enum CodingKeys: String, CodingKey {
            case data, type, width, height, showText
        }
    }
    
    // MARK: - Image Object
    
    struct ImageParams: Codable {
        var source: String
        var width: Int
        var height: Int
        
        enum CodingKeys: String, CodingKey {
            case source, width, height
        }
    }
    
    // MARK: - Shape Object
    
    struct ShapeParams: Codable {
        var type: ShapeType
        var width: Int
        var height: Int
        var color: String
        var strokeWidth: Int
        
        enum CodingKeys: String, CodingKey {
            case type, width, height, color, strokeWidth
        }
    }
    
    // MARK: - Codable Conformance
    
    enum CodingKeys: String, CodingKey {
        case id, type, x, y, width, height, rotation
        case textParams, qrCodeParams, barcodeParams, imageParams, shapeParams
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.type = values.decodeIfPresent(.type) ?? .text
        
        self.x = values.decodeIfPresent(.x) ?? 0
        self.y = values.decodeIfPresent(.y) ?? 0
        self.width = values.decodeIfPresent(.width) ?? 0
        self.height = values.decodeIfPresent(.height) ?? 0
        self.rotation = values.decodeIfPresent(.rotation) ?? 0
        
        switch self.type {
        case .text:
            self.textParams = try? values.decode(.textParams)
            self.qrCodeParams = nil
            self.barcodeParams = nil
            self.imageParams = nil
            self.shapeParams = nil
        case .qrcode:
            self.textParams = nil
            self.qrCodeParams = try? values.decode(.qrCodeParams)
            self.barcodeParams = nil
            self.imageParams = nil
            self.shapeParams = nil
        case .barcode:
            self.textParams = nil
            self.qrCodeParams = nil
            self.barcodeParams = try? values.decode(.barcodeParams)
            self.imageParams = nil
            self.shapeParams = nil
        case .image:
            self.textParams = nil
            self.qrCodeParams = nil
            self.barcodeParams = nil
            self.imageParams = try? values.decode(.imageParams)
            self.shapeParams = nil
        case .shape:
            self.textParams = nil
            self.qrCodeParams = nil
            self.barcodeParams = nil
            self.imageParams = nil
            self.shapeParams = try? values.decode(.shapeParams)
        }
    }
    
    init() {
        self.id = UUID()
        self.type = .text
        self.x = 0
        self.y = 0
        self.width = 0
        self.height = 0
        self.rotation = 0
        self.textParams = TextParams()
        self.qrCodeParams = nil
        self.barcodeParams = nil
        self.imageParams = nil
        self.shapeParams = nil
    }
}

// MARK: - Enums

enum JustifyAlignment: String, Codable {
    case left = "0"
    case center = "1"
    case right = "2"
}

enum ErrorCorrectionLevel: String, Codable {
    case low = "L"
    case medium = "M"
    case quarter = "Q"
    case high = "H"
}

enum BarcodeType: Int, Codable {
    case code128 = 0
    case code39 = 1
    case code93 = 2
    case code11 = 3
    case code128 = 4
    case ean13 = 5
    case ean8 = 6
    case upca = 7
    case upce = 8
    case itf14 = 9
    case msicode = 10
    case pharmanet = 11
    case postnet = 12
    case rss14 = 13
    case rsslimit = 14
    case codabar = 15
}

enum ShapeType: String, Codable {
    case circle
    case rectangle
    case line
}
