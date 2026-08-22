//
//  FontSelector.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import SwiftUI

/// Control for selecting font family in text editing interface
struct FontSelector: View {
    @Binding var fontFamily: String
    @ObservedObject var fontManager: FontManager
    @Binding var onFontChanged: ((String) -> Void)?
    
    private let systemFonts: [String]
    private let customFonts: [UserFont]
    
    init(
        fontFamily: Binding<String>,
        fontManager: FontManager,
        systemFonts: [String] = [],
        customFonts: [UserFont] = [],
        onFontChanged: ((String) -> Void)? = nil
    ) {
        _fontFamily = fontFamily
        self.fontManager = fontManager
        self.systemFonts = systemFonts
        self.customFonts = customFonts
        self.onFontChanged = onFontChanged
    }
    
    var body: some View {
        Picker("Шрифт", selection: $fontFamily) {
            // System fonts
            ForEach(systemFonts, id: \.self) { font in
                Text(font)
            }
            
            // Custom fonts
            ForEach(customFonts, id: \.id) { font in
                Text(font.name)
            }
        }
        .pickerStyle(.menu)
        .onChange(of: fontFamily) { newValue in
            handleFontChange(newValue)
        }
    }
    
    // MARK: - Actions
    
    /// Handle font change
    private func handleFontChange(_ font: String) {
        // Call callback to update the calling view
        onFontChanged?(font)
    }
    
    /// Get available fonts
    func availableFonts() -> [String] {
        var fonts: [String] = systemFonts
        fonts.append(contentsOf: customFonts.map { $0.family })
        return fonts.sorted()
    }
    
    /// Get font by family name
    func font(for family: String) -> UserFont? {
        customFonts.first { $0.family == family }
    }
}

// MARK: - Extension for FontSelector

extension FontSelector {
    /// Preview for FontSelector
    struct Preview: Preview {
        static let fontManager = FontManager()
        static var systemFonts = ["San Francisco", "Helvetica", "Arial"]
        static var customFonts: [UserFont] = []
        
        static var body: some View {
            FontSelector(
                fontFamily: .constant("San Francisco"),
                fontManager: fontManager
            )
        }
    }
}
