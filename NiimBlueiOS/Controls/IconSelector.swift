//
//  IconSelector.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import SwiftUI

/// Control for selecting icons in text editing interface
struct IconSelector: View {
    @Binding var iconName: String
    @ObservedObject var iconManager: IconManager
    @Binding var onIconChanged: ((String) -> Void)?
    
    private let systemIcons: [String]
    private let customIcons: [UserIcon]
    
    init(
        iconName: Binding<String>,
        iconManager: IconManager,
        systemIcons: [String] = [],
        customIcons: [UserIcon] = [],
        onIconChanged: ((String) -> Void)? = nil
    ) {
        _iconName = iconName
        self.iconManager = iconManager
        self.systemIcons = systemIcons
        self.customIcons = customIcons
        self.onIconChanged = onIconChanged
    }
    
    var body: some View {
        Picker("Иконка", selection: $iconName) {
            // System icons
            ForEach(systemIcons, id: \.self) { icon in
                Text(icon)
            }
            
            // Custom icons
            ForEach(customIcons, id: \.id) { icon in
                Text(icon.name)
            }
        }
        .pickerStyle(.menu)
        .onChange(of: iconName) { newValue in
            handleIconChange(newValue)
        }
    }
    
    // MARK: - Actions
    
    /// Handle icon change
    private func handleIconChange(_ icon: String) {
        // Call callback to update the calling view
        onIconChanged?(icon)
    }
    
    /// Get available icons
    func availableIcons() -> [String] {
        var icons: [String] = systemIcons
        icons.append(contentsOf: customIcons.map { $0.name })
        return icons.sorted()
    }
    
    /// Get icon by name
    func icon(for name: String) -> UserIcon? {
        customIcons.first { $0.name == name }
    }
}

// MARK: - Extension for IconSelector

extension IconSelector {
    /// Preview for IconSelector
    struct Preview: Preview {
        static let iconManager = IconManager()
        static var systemIcons = ["star.fill", "star", "heart.fill", "heart"]
        static var customIcons: [UserIcon] = []
        
        static var body: some View {
            IconSelector(
                iconName: .constant("star"),
                iconManager: iconManager
            )
        }
    }
}
