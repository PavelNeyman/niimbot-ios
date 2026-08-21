//
//  CsvParser.swift
//  NiimBlueiOS
//
//  Сервис для парсинга CSV файлов с поддержкой переменных интерполяции
//

import Foundation

/// Сервис для парсинга CSV файлов
struct CsvParser {
    
    /// Парсит CSV файл из данных
    /// - Parameters:
    ///   - data: Данные файла в формате CSV
    ///   - delimiter: Разделитель полей (по умолчанию запятая)
    ///   - quoteChar: Знак кавычек для экранирования (по умолчанию ")
    /// - Returns: Результат парсинга
    static func parse(data: Data, delimiter: Character = ",", quoteChar: Character = "\"") -> CsvParseResult {
        guard let string = String(data: data, encoding: .utf8) else {
            return CsvParseResult(success: false, error: "Не удалось декодировать CSV")
        }
        
        var headers: [String] = []
        var rows: [[String]] = []
        
        // Разбиение на строки
        let lines = string.components(separatedBy: .newlines)
        
        for (index, line) in lines.enumerated() {
            // Пропуск пустых строк
            if line.trimmingCharacters(in: .whitespaces).isEmpty {
                continue
            }
            
            // Разбиение на поля
            let fields = parseLine(line: line, delimiter: delimiter, quoteChar: quoteChar)
            
            if index == 0 {
                headers = fields
            } else {
                rows.append(fields)
            }
        }
        
        let params = CsvParams(
            fileName: "CSV",
            filePath: "",
            headers: headers,
            rows: rows
        )
        
        return CsvParseResult(success: true, params: params)
    }
    
    /// Парсит одну строку CSV
    private static func parseLine(line: String, delimiter: Character, quoteChar: Character) -> [String] {
        var fields: [String] = []
        var field = ""
        var inQuotes = false
        
        for char in line {
            if char == quoteChar {
                inQuotes.toggle()
            } else if char == delimiter && !inQuotes {
                fields.append(field)
                field = ""
            } else {
                field.append(char)
            }
        }
        
        fields.append(field)
        return fields
    }
    
    /// Выполняет интерполяцию переменных в строке
    /// - Parameters:
    ///   - text: Текст с переменными в формате ${headerIndex}
    ///   - headers: Массив заголовков CSV
    ///   - rows: Массив строк данных
    /// - Returns: Интерполированный текст
    static func interpolateVariables(
        text: String,
        headers: [String],
        rows: [[String]]
    ) -> String {
        var result = text
        
        // Поиск паттернов ${number}
        var hasChanges = true
        while hasChanges {
            hasChanges = false
            
            if let range = result.range(of: "\\${\\d+}", options: .regularExpression) {
                if let number = Int(result[range].dropFirst(2).dropLast(1)) {
                    // Получаем значение из заголовка или данных
                    let headerValue = headers.isEmpty ? "" : headers[number]
                    let dataValue = rows.isEmpty ? "" : rows[0][number]
                    
                    // Используем значение из данных, если заголовок пуст
                    let value = headerValue.isEmpty ? dataValue : headerValue
                    
                    // Заменяем ${number} на значение
                    let newValue = "\($0)"
                    result = result.replacingOccurrences(of: "\($0)", with: value)
                    hasChanges = true
                }
            }
        }
        
        return result
    }
    
    /// Выполняет интерполяцию переменных во всех строках
    /// - Parameters:
    ///   - text: Текст с переменными
    ///   - headers: Массив заголовков
    ///   - rows: Массив строк данных
    /// - Returns: Массив интерполированных строк
    static func interpolateVariablesInRows(
        text: String,
        headers: [String],
        rows: [[String]]
    ) -> [String] {
        var result: [String] = []
        
        for row in rows {
            let interpolated = interpolateVariables(
                text: text,
                headers: headers,
                rows: [row]
            )
            result.append(interpolated)
        }
        
        return result
    }
}
