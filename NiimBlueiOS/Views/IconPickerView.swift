//
//  IconPickerView.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import SwiftUI

/// View for selecting icons - displays both system and custom icons
struct IconPickerView: View {
    @Binding var selectedIcon: String
    @ObservedObject var iconManager: IconManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header
                Text("Выберите иконку")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                
                // Separator
                Divider()
                
                // System Icons Section
                Section("Системные иконки") {
                    ForEach(systemIconsSection, id: \.self) { icon in
                        Button(action: {
                            withAnimation {
                                selectedIcon = icon
                            }
                        }) {
                            HStack {
                                Image(systemName: icon)
                                Spacer()
                                // Selected indicator
                                if selectedIcon == icon {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(
                                selectedIcon == icon
                                    ? Color.blue.opacity(0.1)
                                    : Color(.systemGray6)
                            )
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedIcon == icon ? Color.blue : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                    }
                }
                
                Divider()
                
                // Custom Icons Section
                Section("Кастомные иконки") {
                    if customIcons.isEmpty {
                        Text("Нет кастомных иконок")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(customIconsSection, id: \.id) { icon in
                            Button(action: {
                                withAnimation {
                                    selectedIcon = icon.name
                                }
                            }) {
                                HStack {
                                    Text(icon.name)
                                    Spacer()
                                    // Selected indicator
                                    if selectedIcon == icon.name {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .background(
                                    selectedIcon == icon.name
                                        ? Color.blue.opacity(0.1)
                                        : Color(.systemGray6)
                                )
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            selectedIcon == icon.name ? Color.blue : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
            
            // Footer with buttons
            VStack(spacing: 12) {
                if !customIcons.isEmpty {
                    // Add Icon Button
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Добавить свою иконку")
                        }
                        .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                
                // Cancel Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Отмена")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .navigationTitle("")
        .navigationBarItems(leading: nil)
    }
    
    // MARK: - Computed Properties
    
    /// System icons section
    private var systemIconsSection: [String] {
        return systemIcons
    }
    
    /// Custom icons section
    private var customIconsSection: [UserIcon] {
        return customIcons
    }
}

// MARK: - Extension for IconPickerView

extension IconPickerView {
    /// Preview for IconPickerView
    struct Preview: Preview {
        static let iconManager = IconManager()
        
        static var systemIcons = ["star.fill", "star", "heart.fill", "heart"]
        
        static var customIcons: [UserIcon] {
            return [
                UserIcon(
                    id: UUID(),
                    name: "My Icon",
                    data: Data(),
                    size: CGSize(width: 32, height: 32),
                    format: "png"
                ),
                UserIcon(
                    id: UUID(),
                    name: "My Heart",
                    data: Data(),
                    size: CGSize(width: 32, height: 32),
                    format: "png"
                )
            ]
        }
        
        static var body: some View {
            IconPickerView(
                selectedIcon: .constant(""),
                iconManager: iconManager
            )
            .preferredColorScheme(.light)
        }
    }
}
