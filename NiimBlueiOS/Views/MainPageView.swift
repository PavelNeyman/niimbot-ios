import SwiftUI

struct MainPageView: View {
    var body: some View {
        TabView {
            PrinterConnectorView()
                .tabItem {
                    Label("Принтер", systemImage: "printer")
                }
            LabelDesignerView()
                .tabItem {
                    Label("Дизайнер", systemImage: "pencil")
                }
            SavedLabelsView()
                .tabItem {
                    Label("Сохраненные", systemImage: "doc.text")
                }
            PrintPreviewView()
                .tabItem {
                    Label("Печать", systemImage: "print")
                }
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
        .tabBar {
        }
    }
}

#Preview {
    MainPageView()
}

struct PrintPreviewViewWrapper: View {
    @StateObject private var printManager = PrintManager()
    
    var body: some View {
        PrintPreviewView()
            .onAppear {
                // Инициализация параметров печати
            }
    }
}
