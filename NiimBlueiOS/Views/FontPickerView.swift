//
//  FontPickerView.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import SwiftUI

/// View for selecting fonts - displays both system and custom fonts
struct FontPickerView: View {
    @Binding var selectedFont: String
    @StateObject var fontManager = FontManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var systemFonts: [String] = []
    @State private var customFonts: [UserFont] = []
    
    // Load system and custom fonts
    init(selectedFont: Binding<String>) {
        _selectedFont = selectedFont
    }
    
    var body: some View {
        NavigationView {
            // Load fonts
            .task {
                do {
                    try await fontManager.loadSystemFonts()
                } catch {
                    print("Failed to load system fonts: \(error)")
                }
                
                do {
                    try await fontManager.loadCustomFontsAsync()
                } catch {
                    print("Failed to load custom fonts: \(error)")
                }
            }
            
            VStack(spacing: 16) {
                // Header
                Text("Выберите шрифт")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                
                // Separator
                Divider()
                
                // System Fonts Section
                Section("Системные шрифты") {
                    ForEach(systemFontsSection, id: \.self) { font in
                        Button(action: {
                            withAnimation {
                                selectedFont = font
                            }
                        }) {
                            HStack {
                                Text(font)
                                Spacer()
                                // Selected indicator
                                if selectedFont == font {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(
                                selectedFont == font
                                    ? Color.blue.opacity(0.1)
                                    : Color(.systemGray6)
                            )
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedFont == font ? Color.blue : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                    }
                }
                
                Divider()
                
                // Custom Fonts Section
                Section("Кастомные шрифты") {
                    if customFonts.isEmpty {
                        Text("Нет кастомных шрифтов")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(customFontsSection, id: \.id) { font in
                            Button(action: {
                                withAnimation {
                                    selectedFont = font.family
                                }
                            }) {
                                HStack {
                                    Text("\(font.name) — \(font.style)")
                                    Spacer()
                                    // Selected indicator
                                    if selectedFont == font.family {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .background(
                                    selectedFont == font.family
                                        ? Color.blue.opacity(0.1)
                                        : Color(.systemGray6)
                                )
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            selectedFont == font.family ? Color.blue : Color.clear,
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
                if !customFonts.isEmpty {
                    // Add Font Button
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Добавить свой шрифт")
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
    
    /// System fonts section
    private var systemFontsSection: [String] {
        return fontManager.systemFonts
    }
    
    /// Custom fonts section
    private var customFontsSection: [UserFont] {
        return fontManager.customFonts
    }
}

// MARK: - Extension for FontPickerView

extension FontPickerView {
    /// Preview for FontPickerView
    struct Preview: Preview {
        static let fontManager = FontManager()
        
        static var systemFonts = ["San Francisco", "Helvetica", "Arial", "Times New Roman", "Courier New"]
        
        static var customFonts: [UserFont] {
            return [
                UserFont(
                    id: UUID(),
                    name: "My Font",
                    family: "MyFont",
                    style: "Regular",
                    path: URL(fileURLWithPath: "/tmp/test.ttf")
                ),
                UserFont(
                    id: UUID(),
                    name: "My Font Bold",
                    family: "MyFont",
                    style: "Bold",
                    path: URL(fileURLWithPath: "/tmp/test_bold.ttf")
                )
            ]
        }
        
        static var body: some View {
            FontPickerView(
                selectedFont: .constant(""),
                fontManager: fontManager
            )
            .preferredColorScheme(.light)
        }
    }
}
