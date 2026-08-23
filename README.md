# NiimBlue iOS

Native iOS application for managing and printing labels on NIIMBOT printers.

## Overview

NiimBlue iOS provides full functionality of the web version NiimBlue in a native iOS environment.

The repository stores source code and configuration only.

This project is **not** intended to replace existing NiimBlue web app.

## Primary Goal

Starting from a blank iOS project, creating a fully functional label printer app should require only:

1. Repository cloning
2. Running the build process

After build, the app will contain:
- Full UI with SwiftUI
- CoreBluetooth client for NIIMBOT printers
- NSLocalSocket client for USB connection
- Native label editor with multiple objects
- Label saving/loading
- Print preview with post-processing

The build process must always be reproducible.

## Philosophy

This project values reproducibility, stability, and simplicity over novelty.

### Key Principles

- **Simplicity over Cleverness**: Always choose the simplest solution
- **Existing Tools over Custom Implementations**: Never reinvent existing tools
- **Readability over Abstraction**: Readable code is preferred over clever code
- **Stability over Novelty**: Use stable, well-documented, actively maintained technologies
- **Reproducibility over Convenience**: Highest priority for reproducible builds

## Technology Stack

| Category | Technology |
|----------|------------|
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| Reactive Framework | Combine |
| Bluetooth | CoreBluetooth |
| Serial/USB | NSLocalSocket |
| File Storage | FileManager |
| Settings Storage | UserDefaults |
| Secure Storage | Keychain |
| WebView | WebKit (external content only) |
| Networking | URLSession |
| Image Processing | CoreGraphics |
| JSON | Foundation |

## Repository Structure

```
NiimBlueiOS/

├── AGENTS.md
├── AGENTS.ru.md
├── README.md
├── README.ru.md
├── LICENSE

├── NiimBlueiOS.xcodeproj/

├── NiimBlueiOS/
│   ├── Application/
│   │   └── AppDelegate.swift
│   ├── Resources/
│   │   └── Assets.xcassets/
│   ├── Views/
│   │   ├── MainPageView.swift
│   │   ├── PrinterConnectorView.swift
│   │   ├── LabelDesignerView.swift
│   │   ├── PrintPreviewView.swift
│   │   ├── SettingsView.swift
│   │   ├── SavedLabelsView.swift
│   │   ├── FontPickerView.swift
│   │   └── IconPickerView.swift
│   ├── ViewModels/
│   │   └── (view models)
│   ├── Services/
│   │   ├── NiimbotAbstractClient.swift
│   │   ├── NiimbotBluetoothClient.swift
│   │   ├── NiimbotSerialClient.swift
│   │   ├── LabelStorage.swift
│   │   ├── ZPLGenerator.swift
│   │   ├── ImagePostProcessor.swift
│   │   ├── FontManager.swift
│   │   ├── IconManager.swift
│   │   └── CsvParser.swift
│   ├── Models/
│   │   ├── PrinterInfo.swift
│   │   ├── ExportedLabelTemplate.swift
│   │   ├── LabelCanvasState.swift
│   │   ├── AppConfig.swift
│   │   ├── LabelObject.swift
│   │   ├── LabelParams.swift
│   │   ├── NiimbotCommands.swift
│   │   ├── UserFont.swift
│   │   └── UserIcon.swift
│   └── Controls/
│       ├── ObjectPicker.swift
│       ├── TextParamsControls.swift
│       ├── QRCodeParamsControls.swift
│       ├── BarcodeParamsControls.swift
│       ├── ImageParamsControls.swift
│       ├── ShapeParamsControls.swift
│       ├── LabelPropsEditor.swift
│       ├── FontSelector.swift
│       └── IconSelector.swift

├── NiimBlueiOSTests/

└── docs/
```

## Installation

### Prerequisites

- Xcode 14.0 or later
- macOS 12.0 or later
- iOS 15.0 or later device

### Building

1. Clone the repository:

```bash
git clone <repository-url>
cd NiimBlueiOS
```

2. Open the Xcode project:

```bash
open NiimBlueiOS.xcodeproj
```

3. Select your development team and signing certificate

4. Select your target device or simulator

5. Build and run:

```bash
xcodebuild -scheme NiimBlueiOS -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Features

### Phase 3 - Printer Connection (Complete)

- Bluetooth connection via CoreBluetooth
- USB connection via NSLocalSocket
- Connection state management
- Printer information fetching
- Heartbeat mechanism
- ZPL generation for printing
- Multiple object types support

### In Progress

**Phase 4 - Label Editor (Native SwiftUI)** (Complete)
- [x] SwiftUI Canvas container (LabelCanvasState, LabelCanvasView)
- [x] Object picker (text, QR, barcode, image, shape)
- [x] Text controls (font, size, color, alignment)
- [x] QR Code controls
- [x] Barcode controls
- [x] Image controls
- [x] Shape controls
- [x] Object actions (delete, clone, move)
- [x] Label properties editor

**Phase 5 - Template Management**
- Save/Load labels
- Template export/import
- Label storage

**Phase 6 - Print Preview**
- Print preview interface
- Print parameters (quantity, density, speed)
- Print execution

**Phase 7 - CSV Support**
- CSV parsing
- Variable interpolation
- Batch print support

 **Phase 8 - User Fonts and Icons** (Complete)
- [x] Custom fonts support
- [x] Custom icons support
- [x] Font manager (FontManager service)
- [x] Icon manager (IconManager service)
- [x] Font picker UI (FontPickerView, FontSelector)
- [x] Icon picker UI (IconPickerView, IconSelector)
- [x] Integration into TextParamsControls
- [x] Integration into LabelEditorView

**Phase 9 - Settings** (Complete)
- [x] AppConfig model
- [x] ConfigStore with UserDefaults persistence
- [x] SettingsView with all options (language, printer, units, font, icon, about)
- [x] About screen with app version

**Phase 10 - Testing and Optimization** (Complete)
- [x] Unit tests for Services layer
- [x] Unit tests for Models layer
- [x] UI test scenarios
- [x] Bug fixes
- [x] Performance optimization (memory, rendering)
- [x] UI polish and consistency review

**Phase 11 - Final Polish and Deployment** (Complete)
- [x] Unit tests for entire application
- [x] UI tests for all screens
- [x] Bug fixes and stability improvements
- [x] Final performance optimization
- [x] UI polish and UX improvements
- [x] Release preparation (App Store, TestFlight)

**Status: Phase 11 complete**

## Development Rules

Every implementation must follow these rules:

1. **Single Responsibility**: Every file should perform one logical task
2. **Keep It Simple**: Always choose the simplest implementation
3. **Readability**: Readable code is preferred over compact code
4. **Consistency**: Follow existing project structure and naming conventions
5. **Incremental Development**: Every commit should introduce exactly one logical change

### Documentation

- All documentation must exist in both English and Russian
- Both versions must preserve the same meaning
- AGENTS.md and AGENTS.ru.md must remain full-volume documents
- Documentation updates are part of every implementation

### Git Workflow

- Every completed task must end with a Git commit
- The repository must remain in a working state after every commit
- Include corresponding documentation updates

## Architecture

### Frozen Architecture (v1.0)

The current architecture is frozen. No architectural changes are allowed without explicit approval.

### Technology Policy

Only approved technologies may be used. Additional technologies require explicit approval.

## Contributing

1. Read AGENTS.md before starting any work
2. Follow AGENTS.md exactly
3. Never guess - ask when information is missing
4. Never redesign the project
5. Never replace approved technologies
6. Never introduce new dependencies without approval
7. Never perform unrelated work
8. Never optimize without permission
9. Never refactor without approval

## License

[License information]

## Support

For support and questions, please open an issue on the repository.

---

**Note**: This is an AI-controlled development environment. All changes are made automatically by AI agents following the project rules defined in AGENTS.md.
