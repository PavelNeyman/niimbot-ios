//
//  PrinterInfoView.swift
//  NiimBlueiOS
//
//  Вид для отображения информации о принтере
//

import SwiftUI

/// Вид информации о принтере
struct PrinterInfoView: View {
    @ObservedObject var diagnostics: PrinterDiagnostics
    
    var body: some View {
        VStack(spacing: 16) {
            // Заголовок
            HStack {
                Image(systemName: "printer")
                    .foregroundColor(.blue)
                Text("Информация о принтере")
                    .font(.headline)
            }
            .padding(.top)
            
            // Состояние подключения
            VStack(alignment: .leading, spacing: 8) {
                Text("Состояние:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(diagnostics.connectionState.rawValue)
                    .font(.headline)
                    .foregroundColor(
                        diagnostics.connectionState == .connected 
                            ? .green 
                            : .red
                    )
            }
            
            // Название устройства
            VStack(alignment: .leading, spacing: 8) {
                Text("Название устройства:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(diagnostics.deviceName)
                    .font(.body)
            }
            
            // Тип устройства
            VStack(alignment: .leading, spacing: 8) {
                Text("Тип устройства:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(diagnostics.deviceType)
                    .font(.body)
            }
            
            // Модель принтера
            if let model = diagnostics.printerModel {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Модель принтера:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(model)
                        .font(.body)
                }
            }
            
            // ЗPL драйвер
            if let zplVersion = diagnostics.zplDriverVersion {
                VStack(alignment: .leading, spacing: 8) {
                    Text("ZPL драйвер:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(zplVersion)
                        .font(.body)
                }
            }
            
            // Поддерживаемые форматы
            if let formats = diagnostics.supportedLabelFormats {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Поддерживаемые этикетки:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(formats.joined(separator: ", "))
                        .font(.body)
                }
            }
            
            Spacer()
            
            // Кнопка теста
            Button(action: {
                printTestPrint()
            }) {
                HStack {
                    Image(systemName: "test.tube")
                    Text("Тест печати")
                }
                .font(.headline)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal, 30)
            }
        }
        .padding()
    }
    
    private func printTestPrint() {
        // Реализация теста печати
        print("Тест печати запущен")
    }
}

// MARK: - Extension

extension PrinterInfoView {
    private func isDeviceConnected() -> Bool {
        return diagnostics.connectionState == .connected
    }
}

#Preview {
    PrinterInfoView(diagnostics: .constant(PrinterDiagnostics()))
}
