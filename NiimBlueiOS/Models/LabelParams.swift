import Foundation

/// Параметры печати этикетки
struct LabelParams: Codable {
    var width: Int
    var height: Int
    var unit: LabelUnit = .mm
    var dpmm: Int = 203
    var printDirection: PrintDirection = .left
    var shape: LabelShape = .rect
    var split: LabelSplit = .none
    var tailPos: TailPosition = .right
    var margin: LabelMargin = .auto
    var density: Int = 256
    var speed: Int = 5
    
    enum CodingKeys: String, CodingKey {
        case width, height, unit, dpmm, printDirection, shape, split, tailPos, margin, density, speed
    }
    
    enum LabelUnit: String, Codable {
        case mm
        case inch
    }
    
    enum PrintDirection: String, Codable {
        case left = "left"
        case right = "right"
    }
    
    enum LabelShape: String, Codable {
        case rect = "rect"
        case circle = "circle"
        case oval = "oval"
    }
    
    enum LabelSplit: String, Codable {
        case none = "none"
        case left = "left"
        case right = "right"
        case both = "both"
        case top = "top"
        case bottom = "bottom"
    }
    
    enum TailPosition: String, Codable {
        case none = "none"
        case left = "left"
        case right = "right"
        case center = "center"
    }
    
    enum LabelMargin: String, Codable {
        case auto = "auto"
        case none = "none"
        case custom = "custom"
    }
}

/// Параметры текста
struct TextParams {
    var content: String
    var fontSize: Int
    var fontFamily: String
    var color: String
    var justify: JustifyAlignment
    var bold: Bool
    var italic: Bool
    
    init(
        content: String = "",
        fontSize: Int = 16,
        fontFamily: String = "Arial",
        color: String = "#000000",
        justify: JustifyAlignment = .left,
        bold: Bool = false,
        italic: Bool = false
    ) {
        self.content = content
        self.fontSize = fontSize
        self.fontFamily = fontFamily
        self.color = color
        self.justify = justify
        self.bold = bold
        self.italic = italic
    }
}

/// Параметры QR-кода
struct QRCodeParams {
    var data: String
    var dataLength: Int
    var errorCorrectionLevel: ErrorCorrectionLevel
    var moduleSize: Int
    
    init(
        data: String = "",
        dataLength: Int = 4,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium,
        moduleSize: Int = 4
    ) {
        self.data = data
        self.dataLength = dataLength
        self.errorCorrectionLevel = errorCorrectionLevel
        self.moduleSize = moduleSize
    }
}

/// Параметры штрихкода
struct BarcodeParams {
    var data: String
    var type: BarcodeType
    var width: Int
    var height: Int
    var showText: Bool
    
    init(
        data: String = "",
        type: BarcodeType = .code128,
        width: Int = 100,
        height: Int = 50,
        showText: Bool = true
    ) {
        self.data = data
        self.type = type
        self.width = width
        self.height = height
        self.showText = showText
    }
}

/// Параметры изображения
struct ImageParams {
    var source: String
    var width: Int
    var height: Int
    
    init(
        source: String = "",
        width: Int = 100,
        height: Int = 50
    ) {
        self.source = source
        self.width = width
        self.height = height
    }
}

/// Параметры фигуры
struct ShapeParams {
    var type: ShapeType
    var width: Int
    var height: Int
    var color: String
    var strokeWidth: Int
    
    init(
        type: ShapeType = .circle,
        width: Int = 100,
        height: Int = 100,
        color: String = "#000000",
        strokeWidth: Int = 1
    ) {
        self.type = type
        self.width = width
        self.height = height
        self.color = color
        self.strokeWidth = strokeWidth
    }
}

/// Типы шрифтов
enum FontFamily: String, Codable {
    case arial
    case helvetica
    case courier
    case times
    case symbol
    case lucida
    case monaco
    case zapf
    case courierOblique
    case courierBold
    case courierBoldOblique
    case helveticaOblique
    case helveticaBold
    case helveticaBoldOblique
    case lucidaSans
    case lucidaSansOblique
    case lucidaSansBold
    case lucidaSansBoldOblique
    case lucidaTypewriter
    case lucidaTypewriterOblique
    case lucidaTypewriterBold
    case lucidaTypewriterBoldOblique
    case zapfDingbats
}

/// Типы штрихкодов
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

/// Типы фигур
enum ShapeType: String, Codable {
    case circle
    case rectangle
    case line
}

/// Выравнивание текста
enum JustifyAlignment: String, Codable {
    case left = "0"
    case center = "1"
    case right = "2"
}

/// Уровни коррекции ошибок QR-кода
enum ErrorCorrectionLevel: String, Codable {
    case low = "L"
    case medium = "M"
    case quarter = "Q"
    case high = "H"
}
