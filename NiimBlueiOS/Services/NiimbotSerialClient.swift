import Foundation
import Combine
import CoreLocation

/// Serial client для подключения к NIIMBOT через USB (NSLocalSocket)
class NiimbotSerialClient: NiimbotAbstractClient {
    
    // MARK: - Constants
    
    private let defaultPort: Int = 9100
    
    // MARK: - Properties
    
    private var socket: NSLocalSocket?
    private var dataQueue = [Data]()
    private var readCompletionHandler: ((Data) -> Void)?
    private var currentReadCompletionHandler: ((Data) -> Void)?
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: - Connection
    
    override func connect() {
        isConnecting = true
        errorMessage = nil
        
        socket = NSLocalSocket()
        socket?.delegate = self
        socket?.setSocketActive(true)
        
        // Start listening for connections
        socket?.listen(forHost: nil)
    }
    
    override func disconnect() {
        socket?.setSocketActive(false)
        socket?.close()
    }
    
    override func reconnect() {
        disconnect()
        connect()
    }
    
    // MARK: - Heartbeat
    
    override func startHeartbeat(interval: TimeInterval = 30) {
        super.startHeartbeat(interval: interval)
    }
    
    override func stopHeartbeat() {
        super.stopHeartbeat()
    }
    
    private func sendHeartbeat() {
        guard isConnected else { return }
        let heartbeatCommand = "HEARTBEAT\r\n"
        sendCommand(heartbeatCommand)
    }
    
    // MARK: - Command Handling
    
    override func sendCommand(_ command: String) {
        guard let socket = socket,
              isConnected else {
            return
        }
        
        guard let commandData = command.data(using: .utf8) else {
            return
        }
        
        // Add to queue for sending
        dataQueue.append(commandData)
        
        // Send if socket is ready
        if socket.isStreamOpen {
            sendCommandAsync(command)
        }
    }
    
    private func sendCommandAsync(_ command: String) {
        guard let socket = socket,
              let commandData = command.data(using: .utf8),
              isConnected else {
            return
        }
        
        socket.write(commandData)
    }
    
    private func handleIncomingData(_ data: Data) {
        // Process received data
        if let response = parseResponse(from: data) {
            printerInfo = response
        }
    }
    
    // MARK: - Response Parsing
    
    private func parseResponse(from data: Data) -> PrinterInfo? {
        // Implementation for parsing printer responses
        // This is simplified - actual implementation depends on protocol
        return nil
    }
    
    // MARK: - MARK: - Delegation
    
    private func handleDidBecomeReady() {
        isConnecting = false
        
        // Start receiving data
        socket?.stream.readabilityHandler = { [weak self] stream in
            self?.handleReadability(stream)
        }
    }
    
    private func handleDidConnect() {
        isConnecting = false
        isConnected = true
        currentState = .connected
        
        // Start receiving data
        socket?.stream.readabilityHandler = { [weak self] stream in
            self?.handleReadability(stream)
        }
    }
    
    private func handleReadability(_ stream: InputStream) {
        var buffer = [UInt8](repeating: 0, count: 1024)
        
        while stream.hasBytesAvailable {
            let bytesAvailable = stream.availableBytes
            let bufferSize = min(bytesAvailable, buffer.count)
            
            stream.read(&buffer, maxLength: bufferSize)
            
            let data = Data(buffer: Array(buffer))
            handleIncomingData(data)
        }
    }
    
    private func handleDidFail(_ error: Error) {
        handleConnectionError(error)
    }
    
    private func handleDidEnd(_ error: Error?) {
        if let error = error {
            handleConnectionError(error)
        } else {
            isConnected = false
            isConnecting = false
            currentState = .disconnected
        }
    }
    
    private func handleDidClose() {
        isConnected = false
        isConnecting = false
        currentState = .disconnected
    }
}

// MARK: - NSLocalSocketDelegate

extension NiimbotSerialClient: NSLocalSocketDelegate {
    
    func socket(_ socket: NSLocalSocket, didAccept newSocket: NSLocalSocket) {
        // Handle accepted connection
    }
    
    func socket(_ socket: NSLocalSocket, didConnect toHost: String?) {
        handleDidConnect()
    }
    
    func socketDidBecomeReady(_ socket: NSLocalSocket) {
        handleDidBecomeReady()
    }
    
    func socket(_ socket: NSLocalSocket, didFailWithError error: Error) {
        handleDidFail(error)
    }
    
    func socketDidEnd(_ socket: NSLocalSocket, code: Int, error: Error?) {
        handleDidEnd(error)
    }
    
    func socketDidClose(_ socket: NSLocalSocket) {
        handleDidClose()
    }
    
    func socket(_ socket: NSLocalSocket, didReceive data: Data) {
        handleIncomingData(data)
    }
    
    func socket(_ socket: NSLocalSocket, willSend data: Data) {
        // Handle outgoing data
    }
}
