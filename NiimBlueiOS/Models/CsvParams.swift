//
//  CsvParams.swift
//  NiimBlueiOS
//
//  Модель параметров CSV для импорта данных в этикетки
//

import Foundation

/// Параметры CSV для импорта данных
struct CsvParams: Codable, Identifiable {
    let id: UUID = UUID()
    
    /// Имя файла CSV
    var fileName: String
    
    /// Путь к файлу
    var filePath: String
    
    /// Заголовок первого строки (для отображения полей)
    var headers: [String] = []
    
    /// Данные CSV (массив массивов строк)
    var rows: [[String]] = []
    
    /// Количество колонок
    var columnCount: Int {
        guard !rows.isEmpty else { return 0 }
        return rows[0].count
    }
    
    /// Количество строк данных
    var rowCount: Int {
        return rows.count
    }
    
    /// Получение данных по индексу строки и колонки
    func getData(row: Int, column: Int) -> String {
        guard row < rows.count, column < rows[row].count else {
            return ""
        }
        return rows[row][column]
    }
    
    /// Получить всю строку
    func getRow(row: Int) -> [String] {
        guard row < rows.count else {
            return []
        }
        return rows[row]
    }
}

/// Результат парсинга CSV
struct CsvParseResult {
    /// Успешно ли был выполнен парсинг
    let success: Bool
    
    /// Параметры CSV
    var params: CsvParams?
    
    /// Сообщение об ошибке
    var error: String?
}
