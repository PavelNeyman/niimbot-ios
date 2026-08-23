//
//  FeedbackView.swift
//  NiimBlueiOS
//
//  Просмотрщик сообщений фидбека
//

import SwiftUI

/// Просмотрчик сообщений фидбека
struct FeedbackView: View {
    @EnvironmentObject var environment: FeedbackEnvironment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Сообщения")
                    .font(.headline)
                
                Spacer()
                
                // Список сообщений
                List {
                    if let feedback = environment.currentFeedback {
                        FeedbackItem(feedback: feedback)
                    } else {
                        Text("Нет активных сообщений")
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("Сообщения")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Закрыть") {
                            dismiss()
                        }
                    }
                }
            }
            .background(Color(.systemBackground))
        }
    }
}

/// Элемент фидбека
struct FeedbackItem: View {
    let feedback: FeedbackInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Иконка и заголовок
            HStack {
                Image(systemName: getIconName())
                    .foregroundColor(getColor())
                    .frame(width: 24, height: 24)
                
                Text(feedback.message)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .flexibleSpace()
            }
            .padding(.horizontal)
            
            // Тип сообщения
            Text(getTypeString())
                .font(.caption)
                .foregroundColor(getColor())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(getBackgroundColor())
        .cornerRadius(8)
        .shadow(radius: 2)
    }
    
    private func getIconName() -> String {
        switch feedback.type {
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "exclamationmark.circle.fill"
        }
    }
    
    private func getColor() -> Color {
        switch feedback.type {
        case .success:
            return .green
        case .warning:
            return .orange
        case .error:
            return .red
        }
    }
    
    private func getTypeString() -> String {
        switch feedback.type {
        case .success:
            return "Успех"
        case .warning:
            return "Предупреждение"
        case .error:
            return "Ошибка"
        }
    }
    
    private func getBackgroundColor() -> Color {
        switch feedback.type {
        case .success:
            return .green.opacity(0.1)
        case .warning:
            return .orange.opacity(0.1)
        case .error:
            return .red.opacity(0.1)
        }
    }
}

#Preview {
    FeedbackEnvironment {
        FeedbackView()
            .navigationTitle("Сообщения")
    }
}
