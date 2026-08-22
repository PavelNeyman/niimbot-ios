import Foundation

/// Парсер CSV файлов для импорта данных в этикетки
class CsvParser {
    
    /// Парсит CSV файл и возвращает CsvParams
    static func parse(filePath: String) -> CsvParseResult {
        guard let url = URL(fileURLWithPath: filePath) else {
            return CsvParseResult(success: false, params: nil, error: "Не удалось получить URL файла")
        }
        
        do {
            let contents = try String(contentsOf: url, encoding: .utf8)
            guard !contents.isEmpty else {
                return CsvParseResult(success: false, params: nil, error: "Пустой файл CSV")
            }
            
            let result = parse(csv: contents)
            return CsvParseResult(
                success: result.success,
                params: result.params,
                error: result.error
            )
        } catch {
            return CsvParseResult(success: false, params: nil, error: "Ошибка чтения файла: \(error.localizedDescription)")
        }
    }
    
    /// Парсит содержимое CSV строки
    static func parse(csv: String) -> CsvParseResult {
        // Разбиваем на строки
        let lines = csv.components(separatedBy: .newlines)
        
        // Фильтруем пустые строки
        let nonEmptyLines = lines.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        guard !nonEmptyLines.isEmpty else {
            return CsvParseResult(success: false, params: nil, error: "CSV файл пуст")
        }
        
        // Первая строка - заголовки
        let headers = parseRow(row: nonEmptyLines[0])
        
        // Остальные строки - данные
        var rows: [[String]] = []
        for i in 1..<nonEmptyLines.count {
            let row = parseRow(row: nonEmptyLines[i])
            if row.count > 0 {
                rows.append(row)
            }
        }
        
        let params = CsvParams(
            fileName: URL(fileURLWithPath: csv).lastPathComponent,
            filePath: csv,
            headers: headers,
            rows: rows
        )
        
        return CsvParseResult(success: true, params: params, error: nil)
    }
    
    /// Парсит одну строку CSV
    private static func parseRow(row: String) -> [String] {
        // Упрощенный парсер без учета запятых в кавычках
        let components = row.split(separator: ",", maxSplits: .max)
        return components.map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    /// Подставляет переменные из CsvParams в строку
    static func substituteVariables(in csvParams: CsvParams, for row: Int, in column: Int) -> String {
        guard let rowData = csvParams.getDataForRow(row: row),
              let columnValue = rowData[column] else {
            return ""
        }
        
        return columnValue
    }
    
    /// Получает все строки CSV
    static func getAllRows(csv: CsvParams) -> [[String]] {
        return csv.rows
    }
    
    /// Получает количество колонок
    static func getColumnCount(csv: CsvParams) -> Int {
        return csv.columnCount
    }
}

#Preview {
    VStack {
        Text("CsvParser")
            .font(.headline)
    }
}
