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
    
    private let systemIcons: [String]
    private let customIcons: [UserIcon]
    
    init(
        iconName: Binding<String>,
        iconManager: IconManager,
        systemIcons: [String] = [],
        customIcons: [UserIcon] = []
    ) {
        _iconName = iconName
        self.iconManager = iconManager
        self.systemIcons = systemIcons
        self.customIcons = customIcons
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
        // Update text object properties with new icon
        // This is typically called from LabelCanvasView
        // Implementation depends on the calling context
        
        // For now, just log the change
        print("Icon changed to: \(icon)")
        
        // If we need to update state, this would be where it happens
        // In a real implementation, this would update the LabelCanvasState
        // or call a method on the label editor
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
