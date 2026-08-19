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
