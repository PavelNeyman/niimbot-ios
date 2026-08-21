//
//  UserIcon.swift
//  NiimBlueiOS
//
//  Created by AI Agent on 2026-08-21.
//

import Foundation
import CoreGraphics

/// Model for custom icons added by users
struct UserIcon: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let data: Data
    let size: CGSize
    let format: String
    let createdAt: Date
    let updatedAt: Date
    
    /// Check if icon file is valid by extension
    var isValidExtension: Bool {
        let validExtensions = ["png", "jpg", "jpeg", "gif", "bmp"]
        return validExtensions.contains { ext in
            data.count > 0 && pathDescription.lastPathComponent.hasSuffix(ext)
        }
    }
    
    var pathDescription: String {
        // Extract file extension from data filename if available
        // This is a placeholder - actual path handling will be in IconManager
        return "user_icon"
    }
    
    /// Human-readable description
    var description: String {
        return "\(name) (\(format.uppercased()))"
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case data
        case size
        case format
        case createdAt
        case updatedAt
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        data: Data,
        size: CGSize,
        format: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.data = data
        self.size = size
        self.format = format
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.data = try container.decode(Data.self, forKey: .data)
        self.size = try container.decode(CGSize.self, forKey: .size)
        self.format = try container.decode(String.self, forKey: .format)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(data, forKey: .data)
        try container.encode(size, forKey: .size)
        try container.encode(format, forKey: .format)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}

/// Error type for icon-related operations
enum IconError: LocalizedError {
    case invalidData
    case invalidFileFormat
    case fileTooLarge(maxSize: UInt64)
    case decodingFailed
    case encodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidData: return "Invalid icon data"
        case .invalidFileFormat(let format): return "Invalid icon file format: \(format)"
        case .fileTooLarge(let maxSize): return "Icon file exceeds maximum size of \(maxSize) bytes"
        case .decodingFailed: return "Failed to decode icon data"
        case .encodingFailed: return "Failed to encode icon data"
        }
    }
}
