import SwiftUI

struct SettingsView: View {
    @StateObject private var configStore = ConfigStore()
    @State private var showAboutSheet = false
    
    var body: some View {
        NavigationStack {
            Group {
                if configStore.defaultPrinter == nil {
                    EmptySettingsView()
                } else {
                    SettingsList(
                        configStore: configStore
                    )
                }
            }
            .navigationTitle("Настройки")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") {
                        // Возврат в предыдущее представление
                    }
                }
            }
            .sheet(isPresented: $showAboutSheet) {
                AboutView()
            }
        }
    }
}

// MARK: - Empty Settings View

struct EmptySettingsView: View {
    @ObservedObject var configStore: ConfigStore
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Настройки")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("Выберите принтер для настройки")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                // Переход к подключению принтера
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                
                Text("Подключить принтер")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Settings List

struct SettingsList: View {
    @ObservedObject var configStore: ConfigStore
    
    var body: some View {
        List {
            // Информация о версии
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Версия", systemImage: "info.circle")
                        .font(.headline)
                    
                    Text("\(configStore.version) (\(configStore.buildNumber))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            // Язык
            Section {
                Picker("Язык", selection: $configStore.language) {
                    Text("Русский").tag("ru")
                    Text("English").tag("en")
                }
                .pickerStyle(.segmented)
            }
            
            // Принтер
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Принтер", systemImage: "printer")
                        .font(.headline)
                    
                    Text(configStore.defaultPrinter?.model ?? "Не выбран")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            // Единицы измерения
            Section {
                Picker("Единицы", selection: $configStore.defaultUnits) {
                    Text("Мм").tag(.mm)
                    Text("Дюймов").tag(.inch)
                }
                .pickerStyle(.segmented)
            }
            
            // Шрифт
            Section {
                Picker("Шрифт", selection: $configStore.defaultFont) {
                    Text("System").tag("System")
                    Text("Arial").tag("Arial")
                    Text("Helvetica").tag("Helvetica")
                    Text("Courier").tag("Courier")
                    Text("Times").tag("Times")
                    Text("Monaco").tag("Monaco")
                }
                .pickerStyle(.segmented)
            }
            
            // Иконки
            Section {
                Picker("Иконка", selection: $configStore.defaultIcon) {
                    Text("plus").tag("plus")
                    Text("minus").tag("minus")
                    Text("checkmark").tag("checkmark")
                    Text("star").tag("star")
                    Text("heart").tag("heart")
                }
                .pickerStyle(.segmented)
            }
            
            Divider()
            
            // Об About
            Section {
                Button(action: {
                    showAboutSheet = true
                }) {
                    Text("О приложении")
                        .font(.headline)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 8)
            }
        }
        .padding()
    }
}

// MARK: - About View

struct AboutView: View {
    @ObservedObject var configStore: ConfigStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: "printer")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("NiimBlue iOS")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Text("Версия \(configStore.version) (\(configStore.buildNumber))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Приложение для печати этикеток на NIIMBOT принтерах")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Разработано для автоматизации печати")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {
                        // Выход из приложения
                    }) {
                        Text("Закрыть")
                            .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle("О приложении")
        }
    }
}

#Preview {
    SettingsView()
}
