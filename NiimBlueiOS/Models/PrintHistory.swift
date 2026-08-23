//
//  PrintHistory.swift
//  NiimBlueiOS
//
//  Модель и сервис для хранения истории печати
//

import Foundation

/// Запись в истории печати
struct PrintHistoryEntry: Identifiable, Codable {
    let id: UUID
    
    /// Название этикетки
    var labelName: String
    
    /// Дата печати
    var printDate: Date
    
    /// Время печати (в секундах)
    var printDuration: TimeInterval
    
    /// Количество экземпляров
    var quantity: Int
    
    /// Тип подключения
    var connectionType: ConnectionType
    
    /// Тип принтера
    var printerType: PrinterType
    
    /// Статус печати
    var status: PrintStatus
    
    /// Сообщение об ошибке (если было)
    var errorMessage: String?
    
    /// Данные ZPL (если нужно хранить)
    var zplData: String?
    
    /// URL этикетки (если нужно хранить)
    var templateUrl: URL?
}

/// Тип подключения
enum ConnectionType: String, Codable {
    case bluetooth
    case usb
}

/// Тип принтера
enum PrinterType: String, Codable {
    case bluetooth
    case usb
}

/// Статус печати
enum PrintStatus: String, Codable {
    case success = "success"
    case failed = "failed"
    case cancelled = "cancelled"
    
    var description: String {
        switch self {
        case .success:
            return "Успех"
        case .failed:
            return "Ошибка"
        case .cancelled:
            return "Отменено"
        }
    }
}

/// Сервис для работы с историей печати
final class PrintHistoryService: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var entries: [PrintHistoryEntry] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Dependencies
    
    private let fileManager = FileManager.default
    private let documentsDirectory = fileManager.urls(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil
    ).first!
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var historyFileURL: URL?
    
    // MARK: - Public Methods
    
    /// Инициализация сервиса
    init() {
        loadHistory()
    }
    
    /// Добавляет запись в историю
    func addEntry(_ entry: PrintHistoryEntry) {
        entries.insert(entry, at: 0)
        saveHistory()
    }
    
    /// Удаляет запись по ID
    func removeEntry(_ entry: PrintHistoryEntry) {
        entries.removeAll { $0.id == entry.id }
        saveHistory()
    }
    
    /// Очищает всю историю
    func clearHistory() {
        entries.removeAll()
        saveHistory()
    }
    
    /// Фильтрует записи по дате
    func filterByDate(after date: Date) -> [PrintHistoryEntry] {
        return entries.filter { $0.printDate >= date }
    }
    
    /// Фильтрует записи по статусу
    func filterByStatus(_ status: PrintStatus) -> [PrintHistoryEntry] {
        return entries.filter { $0.status == status }
    }
    
    /// Фильтрует записи по типу подключения
    func filterByConnectionType(_ connectionType: ConnectionType) -> [PrintHistoryEntry] {
        return entries.filter { $0.connectionType == connectionType }
    }
    
    /// Получает последние N записей
    func lastN(_ count: Int) -> [PrintHistoryEntry] {
        return Array(entries.suffix(count))
    }
    
    // MARK: - Private Methods
    
    /// Сохраняет историю в файл
    private func saveHistory() {
        historyFileURL = documentsDirectory.appendingPathComponent("print_history.json")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(entries)
            
            if fileManager.fileExists(atPath: historyFileURL?.path) {
                try fileManager.removeItem(at: historyFileURL!)
            }
            
            try data.write(to: historyFileURL!, options: .atomic)
        } catch {
            // Ошибка сохранения - записываем в последнюю запись
            if let lastEntry = entries.last {
                lastEntry.errorMessage = error.localizedDescription
                entries[lastEntry.id] = lastEntry
            }
        }
    }
    
    /// Загружает историю из файла
    private func loadHistory() {
        entries.removeAll()
        
        if let url = historyFileURL {
            do {
                let data = try fileManager.contents(ofURL: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let entries = try? decoder.decode([PrintHistoryEntry].self, from: data) {
                    self.entries = entries
                } else {
                    // Некорректный формат файла - создаём новый
                    print("Ошибка загрузки истории: некорректный формат. Создан новый файл.")
                }
            } catch {
                print("Ошибка загрузки истории: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Extension

extension PrintHistoryService {
    /// Удаляет запись по ID
    func removeEntryById(_ id: UUID) {
        if let index = entries.firstIndex(where: { $0.id == id }),
           let entry = entries[index] {
            removeEntry(entry)
        }
    }
    
    /// Получает общую статистику печати
    func getStatistics() -> PrintStatistics {
        var statistics = PrintStatistics()
        
        for entry in entries {
            statistics.totalPrints += 1
            statistics.totalQuantity += entry.quantity
            statistics.lastPrintDate = max(statistics.lastPrintDate, entry.printDate)
            
            switch entry.status {
            case .success:
                statistics.successfulPrints += 1
            case .failed:
                statistics.failedPrints += 1
            case .cancelled:
                statistics.cancelledPrints += 1
            }
            
            statistics.lastPrinterType = entry.printerType
            statistics.lastConnectionType = entry.connectionType
        }
        
        return statistics
    }
}

/// Статистика печати
struct PrintStatistics {
    var totalPrints: Int = 0
    var successfulPrints: Int = 0
    var failedPrints: Int = 0
    var cancelledPrints: Int = 0
    var totalQuantity: Int = 0
    var lastPrintDate: Date?
    var lastPrinterType: PrinterType?
    var lastConnectionType: ConnectionType?
}

#Preview {
    VStack {
        Text("PrintHistoryService")
            .font(.headline)
    }
}
