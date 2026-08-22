//
//  FontManager.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import Foundation
import UniformTypeIdentifiers

/// Error type for font manager operations
enum FontManagerError: Error, LocalizedError {
    case fontLoadFailed
    case fontCorrupted
    case invalidFontPath
    case fontAlreadyExists
    case fontDeleted
    case fileDoesNotExist
    case fileIsNotAFont
    case invalidFileFormat
    case fileTooLarge(maxSize: UInt64)
    case decodingFailed
    case encodingFailed
    case notAuthorized
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .fontLoadFailed: return "Failed to load font"
        case .fontCorrupted: return "Font file is corrupted"
        case .invalidFontPath: return "Invalid font path"
        case .fontAlreadyExists: return "Font already exists"
        case .fontDeleted: return "Font deleted"
        case .fileDoesNotExist: return "Font file does not exist"
        case .fileIsNotAFont: return "File is not a valid font file"
        case .invalidFileFormat(let format): return "Invalid font file format: \(format)"
        case .fileTooLarge(let maxSize): return "Font file exceeds maximum size of \(maxSize) bytes"
        case .decodingFailed: return "Failed to decode font data"
        case .encodingFailed: return "Failed to encode font data"
        case .notAuthorized: return "Not authorized to perform this operation"
        case .permissionDenied: return "Permission denied for font operation"
        }
    }
}

/// Service for managing custom fonts
class FontManager: ObservableObject {
    /// Published list of system fonts
    @Published var systemFonts: [String] = []
    
    /// Published list of custom fonts
    @Published var customFonts: [UserFont] = []
    
    /// Published error state
    @Published var error: FontManagerError? = nil
    
    /// Font storage directory URL
    private let fontsDirectory: URL
    
    /// File manager for file operations
    private let fileManager = FileManager.default
    
    /// Error domain constant
    private let errorDomain = "FontManagerError"
    
    // MARK: - Initialization
    
    init() {
        // Font storage in Documents directory
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fontsDirectory = documentsURL.appendingPathComponent("NiimBlueiOS/Fonts", isDirectory: true)
        
        // Ensure fonts directory exists
        _ = fileManager.createDirectory(at: fontsDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    // MARK: - System Fonts
    
    /// Load available system fonts
    func loadSystemFonts() async throws {
        error = nil
        self.systemFonts = []
        
        do {
            // iOS 15+: UIFont.fontNames()
            let fonts = UIFont.fontNames() ?? []
            self.systemFonts = fonts
            
            // Sort alphabetically
            self.systemFonts.sort { $0 < $1 }
            
            // Print debug info for development
            print("Loaded \(systemFonts.count) system fonts")
        } catch {
            self.error = .fontLoadFailed
            print("Failed to load system fonts: \(error)")
        }
    }
    
    // MARK: - Custom Fonts Management
    
    /// Save a custom font to the user directory
    func saveFont(_ font: UserFont) throws {
        guard fileManager.fileExists(atPath: font.path.pathURL.pathString) else {
            throw FontManagerError.fileDoesNotExist
        }
        
        // Check if font already exists
        for existingFont in customFonts where existingFont.id == font.id {
            throw FontManagerError.fontAlreadyExists
        }
        
        // Copy font to user directory
        let fontsDir = fontsDirectory
        let fontURL = fontsDir.appendingPathComponent("\(font.family)_\(font.style).\(extractExtension(from: font.path.pathURL))"
            .path)
        
        try fileManager.copyItem(at: font.path, to: fontURL)
        
        // Update the stored path
        font.path = fontURL
        
        // Add to custom fonts list
        customFonts.append(font)
        
        // Notify UI
        self.customFonts = customFonts
        self.error = nil
        
        print("Saved custom font: \(font.name)")
    }
    
    /// Delete a custom font
    func deleteFont(at id: UUID) throws {
        guard let fontIndex = customFonts.firstIndex(where: { $0.id == id }) else {
            throw FontManagerError.fontDeleted
        }
        
        let font = customFonts[fontIndex]
        
        // Delete font file from disk
        guard fileManager.fileExists(atPath: font.path.pathURL.pathString) else {
            throw FontManagerError.fontDeleted
        }
        
        try fileManager.removeItem(at: font.path)
        
        // Remove from list
        customFonts.remove(at: fontIndex)
        
        // Notify UI
        self.customFonts = customFonts
        self.error = nil
        
        print("Deleted custom font: \(font.name)")
    }
    
    /// Load all custom fonts from storage
    func loadCustomFonts() -> [UserFont] {
        return customFonts
    }
    
    /// Check if a font exists in custom fonts
    func fontExists(_ fontId: UUID) -> Bool {
        return customFonts.contains { $0.id == fontId }
    }
    
    /// Get font by name
    func fontByName(_ name: String) -> UserFont? {
        return customFonts.first { $0.name == name }
    }
    
    // MARK: - File Operations
    
    /// Extract file extension from URL
    private func extractExtension(from url: URL) -> String {
        let path = url.path
        if let range = path.range(of: ".") {
            let fileExtension = String(path[range.upperBound..<path.endIndex])
            return fileExtension.lowercased()
        }
        return "unknown"
    }
    
    /// Get file size
    func fileSize(at url: URL) -> UInt64? {
        return fileManager.fileSize(forItem: url)
    }
    
    /// Check if file is a valid font file
    func isFontFile(at url: URL) -> Bool {
        let validExtensions = ["ttf", "otf", "woff", "woff2"]
        return validExtensions.contains { ext in
            url.path.hasSuffix(".\(ext)")
        }
    }
    
    // MARK: - Async Operations
    
    /// Save font asynchronously
    func saveFontAsync(_ font: UserFont) async throws {
        try await withCheckedContinuation { continuation in
            Task {
                do {
                    try await Task.sleep(for: .milliseconds(10)) // Simulate async operation
                    try self.saveFont(font)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Load custom fonts asynchronously
    func loadCustomFontsAsync() async -> [UserFont] {
        return await withCheckedContinuation { continuation in
            Task {
                let fonts = self.loadCustomFonts()
                continuation.resume(returning: fonts)
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private func ensureDirectoryExists(at url: URL) {
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create directory: \(url.path)")
            }
        }
    }
}

// MARK: - Extension for FontManager

extension FontManager {
    /// Clear custom fonts list
    func clearCustomFonts() {
        customFonts = []
    }
    
    /// Get all unique font families
    func fontFamilies() -> [String] {
        Set(customFonts.map { $0.family }).sorted()
    }
    
    /// Get all unique font styles
    func fontStyles() -> [String] {
        Set(customFonts.map { $0.style }).sorted()
    }
}
