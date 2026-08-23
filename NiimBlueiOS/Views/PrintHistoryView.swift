//
//  PrintHistoryView.swift
//  NiimBlueiOS
//
//  Вид для отображения истории печати
//

import SwiftUI

/// Вид истории печати
struct PrintHistoryView: View {
    @ObservedObject var historyService: PrintHistoryService
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                // Статистика
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        // Общая статистика
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Всего печати:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(historyService.getStatistics().totalPrints)")
                                    .font(.headline)
                            }
                            
                            HStack {
                                Text("Успешно:")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Spacer()
                                Text("\(historyService.getStatistics().successfulPrints)")
                                    .font(.headline)
                            }
                            
                            HStack {
                                Text("Ошибка:")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Spacer()
                                Text("\(historyService.getStatistics().failedPrints)")
                                    .font(.headline)
                            }
                            
                            HStack {
                                Text("Отменено:")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Spacer()
                                Text("\(historyService.getStatistics().cancelledPrints)")
                                    .font(.headline)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .padding(.vertical, 8)
                }
                
                // Список записей
                Section {
                    ForEach(historyService.entries) { entry in
                        PrintHistoryRow(entry: entry)
                    }
                }
            }
            .navigationTitle("История печати")
            .toolbar {
                ToolbarItem(placement: .trailing) {
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Очистить")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Очистить историю?", isPresented: $showDeleteConfirmation) {
                Button("Отмена", role: .cancel) {}
                Button("Очистить", role: .destructive) {
                    historyService.clearHistory()
                }
            } message: {
                Text("Вы уверены, что хотите очистить всю историю печати?")
            }
            .refreshable {
                // Перезагрузка при свайпе
                return true
            }
        }
    }
}

/// Строка в истории печати
struct PrintHistoryRow: View {
    let entry: PrintHistoryEntry
    
    var body: some View {
        HStack {
            // Дата и время
            VStack(alignment: .leading, spacing: 2) {
                Text(formatDate(entry.printDate))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(formatDuration(entry.printDuration))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Тип подключения
            VStack(alignment: .trailing, spacing: 4) {
                Text(entry.connectionType.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.trailing, 8)
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
}

// MARK: - Extension

extension PrintHistoryView {
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        let seconds = Int(duration) % 60
        return "\(minutes) мин \(seconds) сек"
    }
}

// MARK: - Extension

extension PrintHistoryRow {
    private func isPrintSuccess(_ entry: PrintHistoryEntry) -> Bool {
        return entry.status == .success
    }
}

#Preview {
    PrintHistoryView(historyService: .constant(PrintHistoryService()))
}
