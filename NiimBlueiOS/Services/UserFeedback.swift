//
//  UserFeedback.swift
//  NiimBlueiOS
//
//  Утилита для пользовательского фидбека
//

import SwiftUI

/// Тип сообщения фидбека
enum FeedbackType {
    case success
    case warning
    case error
}

/// Информация о сообщении фидбека
struct FeedbackInfo {
    let type: FeedbackType
    let message: String
    let duration: TimeInterval = 3.0
}

/// Утилита для показа сообщений фидбека
final class UserFeedbackService: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentFeedback: FeedbackInfo?
    
    // MARK: - Dependencies
    
    private let environment = EnvironmentObject<FeedbackEnvironment>()
    
    // MARK: - Public Methods
    
    /// Показать сообщение о успехе
    /// - Parameters:
    ///   - message: Текст сообщения
    ///   - duration: Время отображения
    func showSuccess(_ message: String, duration: TimeInterval = 3.0) {
        environment.currentFeedback = FeedbackInfo(
            type: .success,
            message: message,
            duration: duration
        )
    }
    
    /// Показать сообщение с предупреждением
    /// - Parameters:
    ///   - message: Текст сообщения
    ///   - duration: Время отображения
    func showWarning(_ message: String, duration: TimeInterval = 3.0) {
        environment.currentFeedback = FeedbackInfo(
            type: .warning,
            message: message,
            duration: duration
        )
    }
    
    /// Показать сообщение об ошибке
    /// - Parameters:
    ///   - message: Текст сообщения
    ///   - duration: Время отображения
    func showError(_ message: String, duration: TimeInterval = 4.0) {
        environment.currentFeedback = FeedbackInfo(
            type: .error,
            message: message,
            duration: duration
        )
    }
    
    /// Показать сообщение с типом ошибки
    /// - Parameters:
    ///   - error: Объект ошибки
    ///   - duration: Время отображения
    func showError(_ error: Error, duration: TimeInterval = 4.0) {
        showError(error.localizedDescription, duration: duration)
    }
    
    /// Скрыть текущее сообщение
    func hide() {
        environment.currentFeedback = nil
    }
    
    // MARK: - Private Methods
    
    /// Получить текущее сообщение фидбека
    private func getFeedback() -> FeedbackInfo? {
        return environment.currentFeedback
    }
}

/// Контекст фидбека для SwiftUI
struct FeedbackEnvironment {
    var currentFeedback: FeedbackInfo?
}

/// Превью для UserFeedbackService
#Preview {
    FeedbackEnvironment {
        VStack {
            Text("UserFeedbackService")
                .font(.headline)
        }
    }
}
