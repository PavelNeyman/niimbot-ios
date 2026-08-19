import SwiftUI

struct PrinterConnectorView: View {
    @StateObject private var connectionStore = PrinterConnectionStore()
    
    var body: some View {
        NavigationView {
            Group {
                if connectionStore.connectionError != nil {
                    errorView
                } else if connectionStore.currentConnectionType == .bluetooth && connectionStore.bluetoothClient?.isConnected == true {
                    bluetoothConnectedView
                } else if connectionStore.currentConnectionType == .usb && connectionStore.serialClient?.isConnected == true {
                    usbConnectedView
                } else {
                    connectionView
                }
            }
            .navigationTitle("Подключение к принтеру")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отключить") {
                        connectionStore.disconnect()
                    }
                    .disabled(connectionStore.bluetoothClient?.isConnected == false &&
                               connectionStore.serialClient?.isConnected == false)
                }
            }
            .onAppear {
                connectionStore.startHeartbeat()
            }
        }
    }
    
    // MARK: - Connection Views
    
    private var connectionView: some View {
        VStack(spacing: 20) {
            Text("Выберите способ подключения:")
                .font(.title2)
                .padding(.horizontal)
            
            Button("Bluetooth") {
                connectionStore.connectBluetooth()
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(connectionStore.bluetoothClient?.isConnected == true ? Color.green : Color.blue)
                    .opacity(connectionStore.bluetoothClient?.isConnected == true ? 0.2 : 1)
            )
            
            Button("USB") {
                connectionStore.connectUSB()
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(connectionStore.serialClient?.isConnected == true ? Color.green : Color.orange)
                    .opacity(connectionStore.serialClient?.isConnected == true ? 0.2 : 1)
            )
            
            if connectionStore.bluetoothClient?.isConnecting == true ||
               connectionStore.serialClient?.isConnecting == true {
                ProgressView()
                    .padding()
            }
        }
        .padding()
    }
    
    private var bluetoothConnectedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bluetooth")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Bluetooth подключено")
                .font(.title)
                .fontWeight(.bold)
            
            Text(connectionStore.bluetoothClient?.printerInfo?.model ?? "Неизвестная модель")
                .font(.headline)
            
            Button("Переключиться на USB") {
                connectionStore.currentConnectionType = .usb
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            
            Button("Отключить") {
                connectionStore.disconnect()
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
        }
        .padding()
    }
    
    private var usbConnectedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "usb")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("USB подключено")
                .font(.title)
                .fontWeight(.bold)
            
            Text(connectionStore.serialClient?.printerInfo?.model ?? "Неизвестная модель")
                .font(.headline)
            
            Button("Переключиться на Bluetooth") {
                connectionStore.currentConnectionType = .bluetooth
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            
            Button("Отключить") {
                connectionStore.disconnect()
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
        }
        .padding()
    }
    
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Ошибка подключения")
                .font(.title)
                .fontWeight(.bold)
            
            Text(connectionStore.connectionError ?? "Неизвестная ошибка")
                .font(.body)
                .foregroundColor(.secondary)
            
            Button("Попробовать снова") {
                connectionStore.reconnect()
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
        }
        .padding()
    }
}

#Preview {
    PrinterConnectorView()
}
