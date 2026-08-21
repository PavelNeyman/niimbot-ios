# Plan for NiimBlue iOS Project

## 📋 Project Status

### Completed Phases
- ✅ **Phase 1** — Repository Foundation
- ✅ **Phase 2** — Xcode Project Setup
- ✅ **Phase 3** — Printer Connection
- ✅ **Phase 4** — Label Editor (Native SwiftUI)
- ✅ **Phase 5** — Template Management
- ✅ **Phase 6** — Print Preview
- ✅ **Phase 7** — CSV Support (basic)

### Current Phase
- 🚧 **Phase 8** — User Fonts and Icons (IN PROGRESS)
- 📋 **Phase 9** — Settings
- 📋 **Phase 10** — Testing and Optimization

---

## 🎯 Current Task: Phase 8 — User Fonts and Icons

### Goal
Implement custom font and icon management for the label editor, allowing users to add, manage, and use custom fonts and icons.

### Files to Create/Modify

#### 1. Models (NiimBlueiOS/Models/)
- `UserFont.swift` — Model for custom fonts
- `UserIcon.swift` — Model for custom icons
- `FontManager.swift` — Service for font management

#### 2. Services (NiimBlueiOS/Services/)
- `FontManager.swift` — Font loading, storage, and management
- `IconManager.swift` — Icon loading and storage (optional)

#### 3. Views (NiimBlueiOS/Views/)
- `FontPickerView.swift` — UI for selecting fonts
- `IconPickerView.swift` — UI for selecting icons (optional)

#### 4. Controls (NiimBlueiOS/Controls/)
- `FontSelector.swift` — SwiftUI control for font selection
- `IconSelector.swift` — SwiftUI control for icon selection

#### 5. Integration
- `LabelEditorView.swift` — Add font picker integration
- `LabelCanvasView.swift` — Apply selected font to text objects

---

## 📝 Implementation Steps

### Step 1: Create UserFont Model
**File:** `NiimBlueiOS/Models/UserFont.swift`

```swift
import Foundation

struct UserFont: Codable, Identifiable {
    let id: UUID
    let name: String
    let family: String
    let style: String
    let path: URL
    let createdAt: Date
    let updatedAt: Date
    
    var isSystemFont: Bool {
        // Check if font is a system font
        return false
    }
}
```

### Step 2: Create UserIcon Model
**File:** `NiimBlueiOS/Models/UserIcon.swift`

```swift
import Foundation

struct UserIcon: Codable, Identifiable {
    let id: UUID
    let name: String
    let iconData: Data
    let size: CGSize
    let format: String
    let createdAt: Date
    let updatedAt: Date
}
```

### Step 3: Create FontManager Service
**File:** `NiimBlueiOS/Services/FontManager.swift`

```swift
import Foundation
import UniformTypeIdentifiers

enum FontManagerError: Error, LocalizedError {
    case fontLoadFailed
    case fontCorrupted
    case invalidFontPath
    
    var errorDescription: String? {
        switch self {
        case .fontLoadFailed: return "Failed to load font"
        case .fontCorrupted: return "Font file is corrupted"
        case .invalidFontPath: return "Invalid font path"
        }
    }
}

class FontManager: ObservableObject {
    @Published var systemFonts: [String] = []
    @Published var customFonts: [UserFont] = []
    
    private let documentsURL: URL
    
    init() {
        documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func loadSystemFonts() async throws {
        // Load available system fonts
    }
    
    func saveFont(_ font: UserFont) throws {
        // Save font to user directory
    }
    
    func deleteFont(at id: UUID) throws {
        // Delete font
    }
    
    func loadCustomFonts() -> [UserFont] {
        // Load saved custom fonts
    }
}
```

### Step 4: Create FontPickerView
**File:** `NiimBlueiOS/Views/FontPickerView.swift`

```swift
import SwiftUI

struct FontPickerView: View {
    @Binding var selectedFont: String
    @ObservedObject var fontManager: FontManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Выберите шрифт")
                .font(.headline)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(fontManager.systemFonts, id: \.self) { font in
                        Button(action: {
                            selectedFont = font
                        }) {
                            Text(font)
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(selectedFont == font ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                    
                    // Custom fonts
                    if !fontManager.customFonts.isEmpty {
                        Text("Кастомные шрифты")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ForEach(fontManager.customFonts, id: \.id) { font in
                            Button(action: {
                                selectedFont = font.family
                            }) {
                                Text(font.name)
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(selectedFont == font.family ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                .tag(font)
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: 200)
        }
    }
}
```

### Step 5: Create FontSelector Control
**File:** `NiimBlueiOS/Controls/FontSelector.swift`

```swift
import SwiftUI

struct FontSelector: View {
    @Binding var fontFamily: String
    @ObservedObject var fontManager: FontManager
    
    var body: some View {
        Picker("Шрифт", selection: $fontFamily) {
            ForEach(fontManager.systemFonts, id: \.self) { font in
                Text(font)
            }
            ForEach(fontManager.customFonts, id: \.id) { font in
                Text(font.name)
            }
        }
        .pickerStyle(.menu)
        .onChange(of: fontFamily) { newValue in
            handleFontChange(newValue)
        }
    }
    
    private func handleFontChange(_ font: String) {
        // Apply font change
    }
}
```

### Step 6: Integrate FontPicker into LabelEditorView
**File:** `NiimBlueiOS/Views/LabelEditorView.swift`

Add font picker to the text editing controls:
- Add `@StateObject var fontManager: FontManager`
- Add `@State private var showFontPicker = false`
- Add button to open font picker
- Integrate with existing text controls

### Step 7: Update LabelCanvasView to Apply Fonts
**File:** `NiimBlueiOS/Views/LabelCanvasView.swift`

- Update text rendering to use selected font
- Apply font family from text object properties

---

## 📋 Phase 8 Tasks Checklist

### UserFont Model
- [ ] Create `UserFont.swift`
- [ ] Define Codable model with all fields
- [ ] Add computed properties (isSystemFont)
- [ ] Add methods for validation

### UserIcon Model
- [ ] Create `UserIcon.swift`
- [ ] Define Codable model with all fields
- [ ] Add methods for image processing

### FontManager Service
- [ ] Create `FontManager.swift`
- [ ] Implement `loadSystemFonts()`
- [ ] Implement `saveFont(_:)`
- [ ] Implement `deleteFont(at:)`
- [ ] Implement `loadCustomFonts()`
- [ ] Add error handling
- [ ] Add ObservableObject for SwiftUI

### FontPickerView
- [ ] Create `FontPickerView.swift`
- [ ] Display system fonts
- [ ] Display custom fonts
- [ ] Add selection state
- [ ] Add visual feedback (highlight selected)
- [ ] Add font preview (optional)

### FontSelector Control
- [ ] Create `FontSelector.swift`
- [ ] Create SwiftUI Picker control
- [ ] Add binding support
- [ ] Add font manager integration

### LabelEditorView Integration
- [ ] Add FontManager to LabelEditorView
- [ ] Add font picker button
- [ ] Connect font picker to LabelCanvasState
- [ ] Update text controls to use new font system

### LabelCanvasView Integration
- [ ] Update text rendering with selected font
- [ ] Apply font from text object
- [ ] Test font rendering

### Icon Support (Optional)
- [ ] Create `UserIcon.swift`
- [ ] Create `IconManager.swift` (optional)
- [ ] Create `IconPickerView.swift` (optional)

### Documentation
- [ ] Update AGENTS.md with Phase 8 progress
- [ ] Update AGENTS.ru.md with Phase 8 progress
- [ ] Update README.md with new features
- [ ] Update README.ru.md with new features

### Testing
- [ ] Add unit tests for FontManager
- [ ] Add unit tests for UserFont model
- [ ] Test font loading
- [ ] Test font saving/loading
- [ ] Test font picker UI

---

## 🔧 Technical Details

### Font Storage Location
```
~/Documents/NiimBlueiOS/Fonts/
```

### Font File Format
- Supported: .ttf, .otf
- Maximum size: 50MB per font file

### System Fonts
- iOS standard fonts: San Francisco, Helvetica, Arial, Times New Roman
- System-ui fonts: Apple system fonts available on iOS

### Icon Storage Location
```
~/Documents/NiimBlueiOS/Icons/
```

### Icon File Format
- Supported: PNG, JPEG, SVG
- Maximum size: 100KB per icon

---

## 📊 Success Criteria

### Functional Requirements
- [ ] User can browse system fonts
- [ ] User can add custom fonts
- [ ] User can select fonts for text objects
- [ ] User can delete custom fonts
- [ ] User can browse custom icons
- [ ] User can select icons for objects

### Non-Functional Requirements
- [ ] Font loading time < 500ms
- [ ] Font picker UI is responsive
- [ ] Memory usage < 50MB for font storage
- [ ] No crashes during font operations

---

## 🚀 Next Steps After Phase 8

### Phase 9 — Settings
- Create AppConfig model
- Create ConfigStore
- Create SettingsView
- Create About screen

### Phase 10 — Testing and Optimization
- Add unit tests
- Add UI tests
- Bug fixes
- Performance optimization
- UI polish

---

## 📚 References

- Apple Human Interface Guidelines for iOS
- iOS Font Management Best Practices
- SwiftUI Picker Usage Guide

---

## ⚠️ Important Notes

1. **Do not change architecture** — Follow existing project structure
2. **Keep it simple** — Use SwiftUI primitives where possible
3. **Follow naming conventions** — Use descriptive names
4. **Update documentation** — Update AGENTS.md and AGENTS.ru.md after each commit
5. **Test thoroughly** — Test on real device when possible

---

## 📅 Estimated Timeline

- Step 1-2 (Models): 1 hour
- Step 3 (FontManager): 2 hours
- Step 4 (FontPickerView): 1 hour
- Step 5 (FontSelector): 1 hour
- Step 6-7 (Integration): 2 hours
- Testing & Documentation: 1 hour

**Total Estimated Time: 8-10 hours**

---

## 🎯 Priority

**HIGH** — Font and icon management is essential for a professional label editor.

---

## ✅ Definition of Done

A task is considered completed only when:
- ✅ Implementation is complete
- ✅ Code follows project architecture
- ✅ Documentation is updated (AGENTS.md, AGENTS.ru.md, README.md)
- ✅ Tests pass (if applicable)
- ✅ Git commit is made
- ✅ Repository is in working state
