import Foundation
import Combine
import CoreBluetooth

/// Хранилище состояния подключения к принтеру
class PrinterConnectionStore: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var bluetoothClient: NiimbotBluetoothClient?
    @Published var serialClient: NiimbotSerialClient?
    @Published var currentConnectionType: ConnectionType = .bluetooth
    @Published var selectedDevice: CBPeripheral?
    @Published var availableDevices: [CBPeripheral] = []
    @Published var connectionError: String?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var bluetoothClient: NiimbotBluetoothClient?
    private var serialClient: NiimbotSerialClient?
    
    // MARK: - Initializers
    
    init() {
        setupClients()
    }
    
    // MARK: - Lifecycle
    
    deinit {
        // Cleanup
    }
    
    // MARK: - Connection Management
    
    func connectBluetooth() {
        currentConnectionType = .bluetooth
        
        // Present device selection UI
    }
    
    func connectUSB() {
        currentConnectionType = .usb
        
        // Present USB connection UI
    }
    
    func disconnect() {
        bluetoothClient?.disconnect()
        serialClient?.disconnect()
    }
    
    func reconnect() {
        bluetoothClient?.reconnect()
        serialClient?.reconnect()
    }
    
    // MARK: - Device Selection
    
    func selectDevice(_ peripheral: CBPeripheral) {
        selectedDevice = peripheral
        bluetoothClient?.peripheralToConnect = peripheral
    }
    
    func updateAvailableDevices(_ devices: [CBPeripheral]) {
        availableDevices = devices
    }
    
    // MARK: - Heartbeat
    
    func startHeartbeat() {
        bluetoothClient?.startHeartbeat(interval: 30)
    }
    
    func stopHeartbeat() {
        bluetoothClient?.stopHeartbeat()
    }
    
    // MARK: - Command Sending
    
    func sendCommand(_ command: String) {
        if currentConnectionType == .bluetooth, let client = bluetoothClient {
            client.sendCommand(command)
        } else if currentConnectionType == .usb, let client = serialClient {
            client.sendCommand(command)
        }
    }
    
    // MARK: - Device Information
    
    func fetchDeviceInformation() {
        if let client = bluetoothClient {
            client.getDeviceInformation()
        } else if let client = serialClient {
            // Implementation for serial
        }
    }
    
    // MARK: - Private Methods
    
    private func setupClients() {
        // Setup Bluetooth client
        let client = NiimbotBluetoothClient()
        client.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.onBluetoothConnectionStatusChanged(isConnected)
            }
            .store(in: &cancellables)
        
        client.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.connectionError = error
            }
            .store(in: &cancellables)
        
        // Setup Serial client
        let serialClient = NiimbotSerialClient()
        serialClient.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.onSerialConnectionStatusChanged(isConnected)
            }
            .store(in: &cancellables)
        
        serialClient.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.connectionError = error
            }
            .store(in: &cancellables)
        
        self.bluetoothClient = client
        self.serialClient = serialClient
    }
    
    private func onBluetoothConnectionStatusChanged(_ isConnected: Bool) {
        // Handle Bluetooth connection status change
    }
    
    private func onSerialConnectionStatusChanged(_ isConnected: Bool) {
        // Handle Serial connection status change
    }
    
    // MARK: - MARK: - MARK
    
    private func handleConnectionError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.connectionError = error.localizedDescription
        }
    }
    
    private func handleConnectionSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.connectionError = nil
        }
    }
}

// MARK: - Connection Type

enum ConnectionType {
    case bluetooth
    case usb
    
    var description: String {
        switch self {
        case .bluetooth:
            return "Bluetooth"
        case .usb:
            return "USB"
        }
    }
}
