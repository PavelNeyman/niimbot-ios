//
//  UserFont.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import Foundation
import UniformTypeIdentifiers

/// Model for custom fonts added by users
struct UserFont: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let family: String
    let style: String
    let path: URL
    let createdAt: Date
    let updatedAt: Date
    
    /// Check if font is a system font
    var isSystemFont: Bool {
        // For now, custom fonts are not system fonts
        return false
    }
    
    /// Check if font file is valid by extension
    var isValidExtension: Bool {
        let validExtensions = ["ttf", "otf", "woff", "woff2"]
        return validExtensions.contains { ext in
            path.lastPathComponent.hasSuffix(".\(ext)")
        }
    }
    
    /// Human-readable description
    var description: String {
        return "\(name) (\(style))"
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case family
        case style
        case path
        case createdAt
        case updatedAt
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        family: String,
        style: String,
        path: URL,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.family = family
        self.style = style
        self.path = path
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.family = try container.decode(String.self, forKey: .family)
        self.style = try container.decode(String.self, forKey: .style)
        self.path = try container.decode(URL.self, forKey: .path)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(family, forKey: .family)
        try container.encode(style, forKey: .style)
        try container.encode(path, forKey: .path)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}

/// Error type for font-related operations
enum FontError: LocalizedError {
    case invalidPath
    case fileDoesNotExist
    case fileIsNotAFont
    case invalidFileFormat
    case fileTooLarge(maxSize: UInt64)
    case decodingFailed
    case encodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidPath: return "Invalid font path"
        case .fileDoesNotExist: return "Font file does not exist"
        case .fileIsNotAFont: return "File is not a valid font file"
        case .invalidFileFormat(let format): return "Invalid font file format: \(format)"
        case .fileTooLarge(let maxSize): return "Font file exceeds maximum size of \(maxSize) bytes"
        case .decodingFailed: return "Failed to decode font data"
        case .encodingFailed: return "Failed to encode font data"
        }
    }
}
