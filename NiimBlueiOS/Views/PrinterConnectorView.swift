import SwiftUI

struct PrinterConnectorView: View {
    var body: some View {
        VStack {
            Text("Подключение к принтеру")
                .font(.largeTitle)
                .padding()
            
            Text("Выберите способ подключения:")
                .font(.title2)
                .padding(.horizontal)
            
            Button("Bluetooth") {
                // TODO: Implement Bluetooth connection
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Button("USB") {
                // TODO: Implement USB connection
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .padding()
    }
}

#Preview {
    PrinterConnectorView()
}
