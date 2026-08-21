import Foundation
import Combine

/// Менеджер печати этикеток
final class PrintManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var printStatus: PrintStatus = .idle
    @Published var errorMessage: String?
    @Published var printProgress: Double = 0
    
    // MARK: - Dependencies
    
    let bluetoothClient: NiimbotBluetoothClient?
    let serialClient: NiimbotSerialClient?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    
    /// Начать печать этикетки
    func printLabel(
        task: PrintTask,
        printerClient: NiimbotAbstractClient
    ) {
        printStatus = .printing
        printProgress = 0
        errorMessage = nil
        
        // Генерируем ZPL код
        let zpl = ZPLGenerator.generateZPL(
            template: task.labelTemplate,
            params: PrintParams(
                quantity: task.quantity,
                density: task.density,
                speed: task.speed
            )
        )
        
        // Отправляем ZPL на принтер
        sendZPLToPrinter(zpl: zpl, client: printerClient) { [weak self] result in
            switch result {
            case .success:
                self?.printStatus = .completed
                self?.printProgress = 100
            case .failure(let error):
                self?.printStatus = .failed
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Отправить ZPL код на принтер
    private func sendZPLToPrinter(zpl: String, client: NiimbotAbstractClient, completion: @escaping (Result<Void, Error>) -> Void) {
        // Отправляем ZPL код принтеру
        client.sendCommand(zpl) { result in
            completion(result)
        }
    }
    
    /// Завершить печать
    func cancelPrint() {
        printStatus = .cancelled
    }
    
    // MARK: - Private Methods
    
    /// Отправить команду на принтер
    private func sendCommand(_ command: String, completion: @escaping (Result<Void, Error>) -> Void) {
        switch client {
        case .bluetooth(let client):
            client.sendCommand(command) { result in
                completion(result.mapError { error in
                    NSError(domain: "PrintManager", code: 1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                })
            }
            
        case .usb(let client):
            client.sendCommand(command) { result in
                completion(result.mapError { error in
                    NSError(domain: "PrintManager", code: 1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                })
            }
        }
    }
}

/// Статус печати
enum PrintStatus: String, CustomStringConvertible {
    case idle
    case printing
    case completed
    case failed
    case cancelled
    
    var description: String {
        switch self {
        case .idle:
            return "Ожидание"
        case .printing:
            return "Печать..."
        case .completed:
            return "Завершено"
        case .failed:
            return "Ошибка"
        case .cancelled:
            return "Отменено"
        }
    }
}
