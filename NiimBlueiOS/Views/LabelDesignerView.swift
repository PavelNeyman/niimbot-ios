import SwiftUI

struct LabelDesignerView: View {
    var body: some View {
        TabView {
            LabelEditorView()
                .tabItem {
                    Image(systemName: "pencil")
                }
                .text("Редактор")
            
            Placeholder()
                .tabItem {
                    Image(systemName: "printer")
                }
                .text("Печать")
            
            SavedLabelsView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                }
                .text("Сохраненные")
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                }
                .text("Настройки")
        }
        .tabViewStyle(.page(indicatorPosition: .leading))
    }
}

#Preview {
    LabelDesignerView()
}
