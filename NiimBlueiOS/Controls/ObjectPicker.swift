import SwiftUI

/// Выбор типа объекта для добавления на этикетку
struct ObjectPicker: View {
    @Binding var selectedType: ObjectType
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Тип объекта:")
                .font(.headline)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(ObjectType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedType = type
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: type.icon)
                                    .font(.system(size: 30))
                                Text(type.displayName)
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        selectedType == type
                                        ? (colorScheme == .dark
                                            ? Color.blue.opacity(0.3)
                                            : Color.blue.opacity(0.2))
                                        : Color(.systemGroupedBackground)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                selectedType == type
                                                ? Color.blue
                                                : Color(.systemGray5),
                                                lineWidth: 2
                                            )
                                    )
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 300)
    }
}

#Preview {
    ObjectPicker(selectedType: .constant(.text))
}
