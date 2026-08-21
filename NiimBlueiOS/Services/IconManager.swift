//
//  IconManager.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import Foundation
import CoreGraphics

/// Error type for icon manager operations
enum IconManagerError: Error, LocalizedError {
    case iconLoadFailed
    case iconCorrupted
    case invalidIconPath
    case iconAlreadyExists
    case iconDeleted
    case fileDoesNotExist
    case fileIsNotAIcon
    case invalidFileFormat
    case fileTooLarge(maxSize: UInt64)
    case decodingFailed
    case encodingFailed
    case notAuthorized
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .iconLoadFailed: return "Failed to load icon"
        case .iconCorrupted: return "Icon file is corrupted"
        case .invalidIconPath: return "Invalid icon path"
        case .iconAlreadyExists: return "Icon already exists"
        case .iconDeleted: return "Icon deleted"
        case .fileDoesNotExist: return "Icon file does not exist"
        case .fileIsNotAIcon: return "File is not a valid icon file"
        case .invalidFileFormat(let format): return "Invalid icon file format: \(format)"
        case .fileTooLarge(let maxSize): return "Icon file exceeds maximum size of \(maxSize) bytes"
        case .decodingFailed: return "Failed to decode icon data"
        case .encodingFailed: return "Failed to encode icon data"
        case .notAuthorized: return "Not authorized to perform this operation"
        case .permissionDenied: return "Permission denied for icon operation"
        }
    }
}

/// Service for managing custom icons
class IconManager: ObservableObject {
    /// Published list of system icons (placeholders)
    @Published var systemIcons: [String] = []
    
    /// Published list of custom icons
    @Published var customIcons: [UserIcon] = []
    
    /// Published error state
    @Published var error: IconManagerError? = nil
    
    /// Icon storage directory URL
    private let iconsDirectory: URL
    
    /// File manager for file operations
    private let fileManager = FileManager.default
    
    /// Error domain constant
    private let errorDomain = "IconManagerError"
    
    // MARK: - Initialization
    
    init() {
        // Icon storage in Documents directory
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        iconsDirectory = documentsURL.appendingPathComponent("NiimBlueiOS/Icons", isDirectory: true)
        
        // Ensure icons directory exists
        _ = fileManager.createDirectory(at: iconsDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    // MARK: - System Icons
    
    /// Load available system icons (placeholders)
    func loadSystemIcons() async throws {
        error = nil
        self.systemIcons = []
        
        // Use CFAvailableIcons for system icons
        guard let icons = CFAvailableIcons() else {
            return
        }
        
        // Filter to commonly used icons
        for icon in icons {
            let iconName = icon.iconName
            // Common iOS system icons
            if !systemIcons.contains(iconName) {
                systemIcons.append(iconName)
            }
        }
        
        // Sort alphabetically
        self.systemIcons.sort { $0 < $1 }
        
        print("Loaded \(systemIcons.count) system icons")
    }
    
    // MARK: - Custom Icons Management
    
    /// Save a custom icon to the user directory
    func saveIcon(_ icon: UserIcon) throws {
        guard fileManager.fileExists(atPath: icon.path.pathURL.pathString) else {
            throw IconManagerError.fileDoesNotExist
        }
        
        // Check if icon already exists
        for existingIcon in customIcons where existingIcon.id == icon.id {
            throw IconManagerError.iconAlreadyExists
        }
        
        // Copy icon to user directory
        let iconsDir = iconsDirectory
        let iconURL = iconsDir.appendingPathComponent("\(icon.name).\(extractExtension(from: icon.path.pathURL))"
            .path)
        
        try fileManager.copyItem(at: icon.path, to: iconURL)
        
        // Update the stored path
        icon.path = iconURL
        
        // Add to custom icons list
        customIcons.append(icon)
        
        // Notify UI
        self.customIcons = customIcons
        self.error = nil
        
        print("Saved custom icon: \(icon.name)")
    }
    
    /// Delete a custom icon
    func deleteIcon(at id: UUID) throws {
        guard let iconIndex = customIcons.firstIndex(where: { $0.id == id }) else {
            throw IconManagerError.iconDeleted
        }
        
        let icon = customIcons[iconIndex]
        
        // Delete icon file from disk
        guard fileManager.fileExists(atPath: icon.path.pathURL.pathString) else {
            throw IconManagerError.iconDeleted
        }
        
        try fileManager.removeItem(at: icon.path)
        
        // Remove from list
        customIcons.remove(at: iconIndex)
        
        // Notify UI
        self.customIcons = customIcons
        self.error = nil
        
        print("Deleted custom icon: \(icon.name)")
    }
    
    /// Load all custom icons from storage
    func loadCustomIcons() -> [UserIcon] {
        return customIcons
    }
    
    /// Check if an icon exists in custom icons
    func iconExists(_ iconId: UUID) -> Bool {
        return customIcons.contains { $0.id == iconId }
    }
    
    /// Get icon by name
    func iconByName(_ name: String) -> UserIcon? {
        return customIcons.first { $0.name == name }
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
    
    /// Check if file is a valid icon file
    func isIconFile(at url: URL) -> Bool {
        let validExtensions = ["png", "jpg", "jpeg", "gif", "bmp", "svg", "ico"]
        return validExtensions.contains { ext in
            url.path.hasSuffix(".\(ext)")
        }
    }
    
    // MARK: - Async Operations
    
    /// Save icon asynchronously
    func saveIconAsync(_ icon: UserIcon) async throws {
        try await withCheckedContinuation { continuation in
            Task {
                do {
                    try await Task.sleep(for: .milliseconds(10)) // Simulate async operation
                    try self.saveIcon(icon)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Load custom icons asynchronously
    func loadCustomIconsAsync() async -> [UserIcon] {
        return await withCheckedContinuation { continuation in
            Task {
                let icons = self.loadCustomIcons()
                continuation.resume(returning: icons)
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

// MARK: - Extension for IconManager

extension IconManager {
    /// Clear custom icons list
    func clearCustomIcons() {
        customIcons = []
    }
    
    /// Get all unique icon names
    func iconNames() -> [String] {
        Set(customIcons.map { $0.name }).sorted()
    }
    
    /// Get all unique icon formats
    func iconFormats() -> [String] {
        Set(customIcons.map { $0.format }).sorted()
    }
}
