import Foundation
import Combine

/// Базовый класс для клиентов NIIMBOT принтеров
class NiimbotAbstractClient: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isConnected: Bool = false
    @Published var isConnecting: Bool = false
    @Published var errorMessage: String?
    @Published var printerInfo: PrinterInfo?
    
    // MARK: - Combine Publishers
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - State Machine
    
    private enum ConnectionState {
        case disconnected
        case connecting
        case connected
        case error(String)
    }
    
    private var currentState: ConnectionState = .disconnected
    
    // MARK: - Properties
    
    private(set) var commandQueue = DispatchQueue(label: "com.niimbot.client.commands")
    private var heartbeatTimer: Timer?
    
    // MARK: - Initializers
    
    init() {
        super.init()
        setupStateMachine()
    }
    
    // MARK: - Lifecycle
    
    deinit {
        heartbeatTimer?.invalidate()
    }
    
    // MARK: - Connection Management
    
    func connect() {
        switch currentState {
        case .disconnected, .error:
            connectToDevice()
        case .connecting:
            errorMessage = "Подключение уже в процессе"
        case .connected:
            isConnected = true
        }
    }
    
    func disconnect() {
        disconnectFromDevice()
    }
    
    func reconnect() {
        disconnectFromDevice()
        connectToDevice()
    }
    
    // MARK: - Heartbeat
    
    func startHeartbeat(interval: TimeInterval = 30) {
        heartbeatTimer?.invalidate()
        
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.sendHeartbeat()
        }
    }
    
    func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    // MARK: - Command Sending
    
    func sendCommand(_ command: String) {
        commandQueue.async { [weak self] in
            self?.sendCommandAsync(command)
        }
    }
    
    private func sendCommandAsync(_ command: String) {
        // Override in subclasses
    }
    
    // MARK: - Error Handling
    
    private func handleConnectionError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = false
            self?.isConnecting = false
            self?.currentState = .error(error.localizedDescription)
            self?.errorMessage = error.localizedDescription
        }
    }
    
    private func handleConnectionSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.isConnected = true
            self?.isConnecting = false
            self?.currentState = .connected
            self?.errorMessage = nil
        }
    }
    
    // MARK: - State Machine
    
    private func setupStateMachine() {
        Publishers.CombineLatest4(
            $isConnected,
            $isConnecting,
            $errorMessage,
            $printerInfo
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] connected, connecting, error, info in
            self?.updateStateMachine(
                connected: connected,
                connecting: connecting,
                error: error,
                info: info
            )
        }
        .store(in: &cancellables)
    }
    
    private func updateStateMachine(
        connected: Bool,
        connecting: Bool,
        error: String?,
        info: PrinterInfo?
    ) {
        if connected && !connecting && error == nil {
            currentState = .connected
        } else if !connected && !connecting {
            if let errorMessage = error {
                currentState = .error(errorMessage)
            } else {
                currentState = .disconnected
            }
        } else if connecting && !connected {
            currentState = .connecting
        }
    }
}
