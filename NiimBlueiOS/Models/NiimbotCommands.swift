import Foundation

/// Ключевые команды для NIIMBOT принтеров
enum NiimbotCommandId: UInt16, CaseIterable {
    case GetDeviceInformation = 0x0001
    case PrintZPL = 0x0002
    case GetStatus = 0x0003
    case Heartbeat = 0x0004
    case SetSound = 0x0005
    case SetPrintDirection = 0x0006
    case SetPrintDensity = 0x0007
    case SetPrintSpeed = 0x0008
    case SetMarginLeft = 0x0009
    case SetMarginRight = 0x000A
    case SetMarginTop = 0x000B
    case SetMarginBottom = 0x000C
    case SetLabelWidth = 0x000D
    case SetLabelHeight = 0x000E
    case GetDeviceInformationExtended = 0x000F
    case GetRFIDStatus = 0x0010
    case SetRFID = 0x0011
    case FirmwareUpdate = 0x0012
    case Reset = 0x0013
    case GetVersion = 0x0014
    case GetFirmwareVersion = 0x0015
    case GetMACAddress = 0x0016
    case GetIMEI = 0x0017
    case GetSerialNumber = 0x0018
    case SetBrightness = 0x0019
    case GetBrightness = 0x001A
    case SetContrast = 0x001B
    case GetContrast = 0x001C
    case SetPaperType = 0x001D
    case GetPaperType = 0x001E
    
    var description: String {
        switch self {
        case .GetDeviceInformation:
            return "Получить информацию о устройстве"
        case .PrintZPL:
            return "Печать ZPL"
        case .GetStatus:
            return "Получить статус"
        case .Heartbeat:
            return "Heartbeat"
        case .SetSound:
            return "Настройка звука"
        case .SetPrintDirection:
            return "Направление печати"
        case .SetPrintDensity:
            return "Плотность печати"
        case .SetPrintSpeed:
            return "Скорость печати"
        case .SetMarginLeft:
            return "Левый отступ"
        case .SetMarginRight:
            return "Правый отступ"
        case .SetMarginTop:
            return "Верхний отступ"
        case .SetMarginBottom:
            return "Нижний отступ"
        case .SetLabelWidth:
            return "Ширина этикетки"
        case .SetLabelHeight:
            return "Высота этикетки"
        case .GetDeviceInformationExtended:
            return "Расширенная информация о устройстве"
        case .GetRFIDStatus:
            return "Статус RFID"
        case .SetRFID:
            return "Настройка RFID"
        case .FirmwareUpdate:
            return "Обновление прошивки"
        case .Reset:
            return "Сброс"
        case .GetVersion:
            return "Получить версию"
        case .GetFirmwareVersion:
            return "Версия прошивки"
        case .GetMACAddress:
            return "MAC адрес"
        case .GetIMEI:
            return "IMEI"
        case .GetSerialNumber:
            return "Номер серийный"
        case .SetBrightness:
            return "Яркость"
        case .GetBrightness:
            return "Получить яркость"
        case .SetContrast:
            return "Контрастность"
        case .GetContrast:
            return "Получить контрастность"
        case .SetPaperType:
            return "Тип бумаги"
        case .GetPaperType:
            return "Получить тип бумаги"
        }
    }
}

/// Команда для отправки на принтер
struct PrinterCommand {
    let id: NiimbotCommandId
    let data: Data?
    
    var command: String {
        var command = "\(id.rawValue)"
        
        if let data = data {
            command += ":" + data.map { String(format: "%02X", $0) }.joined()
        }
        
        return command
    }
}

/// Ответ от принтера
struct PrinterResponse: Codable {
    let status: Int
    let command: String?
    let data: Data?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case status, command, data, errorMessage
    }
}
