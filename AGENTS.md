# AGENTS.md

> Project: NiimBlue iOS — Native iOS Label Printer App
>
> Document Version: 1.0
>
> Status: Approved

---

# Quick Start for AI Agents

Before performing any work in this repository, complete the following steps in order:

1. Read the latest version of **AGENTS.md** in its entirety.
2. Review the **Project State** section to determine the current implementation status.
3. Review the **Roadmap** and identify the next planned task.
4. Verify that the requested task does not conflict with the project rules or architecture.
5. If any required information is missing or ambiguous, stop and ask the repository owner before making changes.
6. Implement only the requested task.
7. Update all affected documentation in both English and Russian.
8. Update the **Roadmap** and **Project State** if required.
9. Verify that the repository remains in a working state.
10. Complete the task with a Git commit.

Failure to follow these steps is considered a violation of the project rules.

---

This document is the single source of truth for the project.

Every AI agent, contributor and automation tool working with this repository must read and follow this document before performing any action.

Conversation history must never replace AGENTS.md.

**AGENTS.md and AGENTS.ru.md must always remain full-volume documents.** They must never be replaced by condensed, summarized, or abbreviated versions. See **Documentation Rules → AGENTS.md integrity** and **Final Rules**.

---

# 1. Project Overview

## Purpose

NiimBlue iOS is a native iOS application for managing and printing labels on NIIMBOT printers.

Its purpose is to provide full functionality of the web version NiimBlue in a native iOS environment.

The repository stores source code and configuration only.

The project is **not** intended to replace existing NiimBlue web app.

---

## Primary Goal

Starting from a blank iOS project, creating a fully functional label printer app should require only:

1. Repository cloning.
2. Running the build process.

After build the app should contain:

- full UI with SwiftUI;
- CoreBluetooth client for NIIMBOT printers;
- NSLocalSocket client for USB connection;
- native label editor with multiple objects;
- label saving/loading;
- print preview with post-processing.

The build process must always be reproducible.

---

# 2. Project Philosophy

The philosophy of this project is intentionally conservative.

The project values reproducibility, stability and simplicity over novelty.

---

## Simplicity over Cleverness

Always choose the simplest solution.

Avoid unnecessary abstraction.

Do not introduce complexity unless absolutely required.

---

## Existing Tools over Custom Implementations

Never reinvent existing tools.

If a mature tool already solves the problem correctly, use it.

Do not create:

- custom frameworks;
- custom networking layers;
- custom UI components;
- custom configuration systems.

---

## Readability over Abstraction

Code should be understandable.

Readable code is preferred over clever code.

Duplicated but readable code is often preferable to highly abstract implementations.

---

## Stability over Novelty

Do not replace stable technologies simply because newer alternatives exist.

Use technologies that are:

- stable;
- well documented;
- actively maintained.

---

## Reproducibility over Convenience

The highest priority of this project is reproducibility.

Whenever convenience conflicts with reproducibility, reproducibility always wins.

---

# 3. Project Principles

The following principles are immutable.

They may only be modified after explicit approval from the repository owner.

---

## Git is the Single Source of Truth

Every configuration belongs in Git.

Nothing should exist only on a local machine.

The repository always represents the desired app state.

---

## Documentation is Part of the Project

Documentation is mandatory.

Documentation has equal importance to implementation.

Every functional change must include documentation updates.

---

## One Repository — One Truth

The repository completely describes the application.

No undocumented manual configuration should ever be required.

---

## Declarative Configuration

Configuration should describe the desired final state.

Prefer declarative configuration whenever possible.

---

# 4. Frozen Architecture

The architecture of this project is frozen.

AI agents and contributors are not allowed to redesign the architecture.

Architectural changes require explicit approval.

This includes:

- repository structure;
- installation flow;
- selected technologies;
- project philosophy;
- development workflow.

---

# 5. Technology Policy

Only approved technologies may be used.

Current technology stack:

- Swift 5.9+
- SwiftUI
- Combine
- CoreBluetooth
- NSLocalSocket
- FileManager
- UserDefaults
- Keychain
- WebKit (only for external content, not for Fabric.js)

### Approved Technology Stack

| Category | Technology |
|-----------|------------|
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

Additional technologies require explicit approval.

Approved technologies may not be replaced without approval.

---

# 6. AI Agent Rules

Every AI agent working on this repository must follow these rules.

---

## Read Before Writing

Before starting any task the agent must:

1. Read AGENTS.md.
2. Determine the current project state.
3. Read the Roadmap.
4. Determine the next planned task.

Conversation history must never replace AGENTS.md.

---

## Never Guess

Never make assumptions.

If required information is missing:

STOP.

Ask the repository owner.

---

## Follow AGENTS.md Exactly

The rules defined in AGENTS.md are mandatory.

They have priority over personal preferences, assumptions and previous conversations.

---

## Do Not Change Architecture

Architecture is frozen.

Do not redesign the project.

Do not restructure the repository.

Do not replace approved technologies.

---

## Do Not Introduce New Dependencies

Adding any dependency requires explicit approval.

Never introduce new tools because they appear more convenient.

---

## Do Not Perform Unrequested Work

Only implement the requested task.

Never:

- refactor unrelated code;
- optimize unrelated code;
- modify unrelated documentation;
- reorganize unrelated files.

---

## Do Not Optimize Without Permission

Never perform:

- optimization;
- cleanup;
- redesign;
- simplification;
- refactoring;

unless explicitly requested.

---

## Do Not Compress or Shorten AGENTS.md

**AGENTS.md** and **AGENTS.ru.md** must always remain **full-volume** documents (complete section structure and substance).

Agents must **never**:

- replace either file with a condensed, summarized, "sync note", stub, or abbreviated version;
- delete large sections to "simplify" or save tokens;
- merge many sections into a short overview while dropping detail.

Allowed changes are **only** targeted actualization (precise edits that keep the document complete and accurate), and only with **explicit owner approval** for non-mutable content (see **Documentation Rules → AGENTS.md integrity** and **Immutable Sections**).

Mutable Sections (§25) may still be updated as defined there without treating the whole file as free to rewrite.

---

## Ask Instead of Deciding

If multiple valid implementations exist and AGENTS.md does not specify which one should be used:

STOP.

Ask the repository owner.

Never choose independently.

---

# 7. Code Review and Refactoring Policy

Before performing:

- code review;
- architecture review;
- refactoring;
- large modifications;

the agent must first perform a complete analysis.

The analysis must include:

- project structure;
- affected components;
- documentation;
- architecture compliance;
- documentation compliance;
- dependency analysis.

The result must be presented as a report.

Each issue must include:

- description;
- consequences;
- severity:
  - Critical
  - High
  - Medium
  - Low
- recommended solution.

No implementation changes may be performed before explicit approval.

---

# 8. Immutable Sections

The following sections are immutable.

They may not be modified without explicit approval.

- Project Overview
- Project Philosophy
- Project Principles
- Frozen Architecture
- Technology Policy
- AI Agent Rules
- Repository Structure
- Development Rules
- Documentation Rules
- Definition of Done

The only exception is updating the document version after approval.

---

# 9. Repository Structure

The repository is the complete definition of the application.

Every directory has exactly one responsibility.

The repository structure is considered part of the project architecture and may not be modified without explicit approval.

```text
NiimBlueiOS/

├── AGENTS.md
├── AGENTS.ru.md
├── README.md
├── README.ru.md
├── LICENSE
│
├── NiimBlueiOS.xcodeproj/
│
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
│   │   └── SavedLabelsView.swift
│   ├── ViewModels/
│   │   └── (view models)
│   ├── Services/
│   │   ├── NiimbotBluetoothClient.swift
│   │   ├── NiimbotSerialClient.swift
│   │   ├── LabelStorage.swift
│   │   ├── ZPLGenerator.swift
│   │   ├── ImagePostProcessor.swift
│   │   └── CsvParser.swift
│   ├── Models/
│   │   ├── PrinterInfo.swift
│   │   ├── ExportedLabelTemplate.swift
│   │   ├── LabelCanvasState.swift
│   │   ├── AppConfig.swift
│   │   └── ...
│   └── Controls/
│       ├── ObjectPicker.swift
│       ├── TextParamsControls.swift
│       ├── QRCodeParamsControls.swift
│       ├── BarcodeParamsControls.swift
│       ├── ImageParamsControls.swift
│       ├── ShapeParamsControls.swift
│       └── LabelPropsEditor.swift
│
├── NiimBlueiOSTests/
│
└── docs/
```

---

## Repository Responsibilities

### AGENTS.md

The primary project document.

Defines:

- project rules;
- architecture;
- roadmap;
- development workflow;
- AI behavior;
- current project state.

Every AI agent must read this document before starting work.

**AGENTS.md** and **AGENTS.ru.md** must always be maintained as **full-volume** documents. See **Documentation Rules → AGENTS.md integrity**.

---

### README.md

Primary English documentation.

Contains:

- project overview;
- installation instructions;
- usage instructions;
- contribution guide.

---

### README.ru.md

Primary Russian documentation.

Must always remain synchronized with README.md.

Synchronization means preserving meaning rather than performing a literal translation.

---

### NiimBlueiOS/

Contains the main iOS application source code.

Organized by architectural layers:

- `Application/` — AppDelegate
- `Resources/` — Assets.xcassets
- `Views/` — SwiftUI views
- `ViewModels/` — View models and state management
- `Services/` — Business logic and external services
- `Models/` — Data models
- `Controls/` — Reusable UI controls

---

### NiimBlueiOS.xcodeproj/

Contains Xcode project configuration.

---

### NiimBlueiOSTests/

Contains unit and UI tests.

---

### docs/

Contains additional project documentation.

Examples:

- API documentation;
- architecture diagrams;
- migration guides;
- developer setup.

---

# 10. Development Rules

Every implementation must follow these rules.

---

## Single Responsibility

Every file should perform one logical task.

Large files should be split into smaller files.

---

## Keep It Simple

Always choose the simplest implementation.

Avoid unnecessary abstractions.

---

## Readability

Readable code is preferred over compact code.

Avoid unnecessary complexity.

---

## Consistency

Follow the existing project structure.

Follow existing naming conventions.

Follow existing implementation style.

---

## Incremental Development

Every commit should introduce exactly one logical change.

Large features should be implemented as multiple independent tasks whenever practical.

---

# 11. Documentation Rules

Documentation is mandatory.

---

## Languages

Every document must exist in:

- English;
- Russian.

Both versions must preserve the same meaning.

Literal translation is not required.

---

### Language Equality

Neither language version is considered canonical.

Both language versions are equally authoritative and must always remain synchronized.

Any change made to one version must be reflected in the other within the same commit while preserving meaning rather than performing a literal translation.

---

## Documentation Requirements

Every document should describe:

- purpose;
- implementation;
- usage;
- limitations;
- dependencies.

---

## Documentation Updates

Documentation updates are part of every implementation.

Updating documentation later is prohibited.

---

## AGENTS.md integrity (full volume)

**AGENTS.md** and **AGENTS.ru.md** are the project's single source of truth for agents and must always remain **complete, full-volume** documents.

### Required

- Keep the full section structure and substantive content in **both** languages.
- When actualizing rules or installation flow, apply **targeted edits** only; do not rewrite the file as a short summary.
- After any approved change, both language versions must remain full and meaning-aligned.

### Prohibited without explicit owner approval

- Replacing either file with a condensed, summarized, stub, or "errata-only" version.
- Removing or collapsing major sections for brevity, token limits, or convenience.
- Treating "language equality" as license to ship a short RU (or EN) while the other stays long.

### Approval

- Edits to **immutable** parts of AGENTS.md / AGENTS.ru.md require **explicit owner consent** before the change is written to the repository.
- Updates limited to **Mutable Sections** (§25) follow the existing mutable rules and still must not reduce the document to a summary.

This integrity rule itself is part of **Documentation Rules** and **AI Agent Rules** and may not be removed or weakened without owner approval.

---

# 12. Git Workflow

Every completed logical task must end with a Git commit.

---

## Commit Rules

Every commit should:

- leave the repository in a working state;
- include corresponding documentation updates;
- update the Roadmap;
- update the Current Status if necessary.

---

## Repository State

The repository should remain functional after every commit.

Broken intermediate states should not be committed unless explicitly requested.

---

# 13. Branch Strategy

Current branch strategy:

```text
main
```

Additional branching strategies require explicit approval.

---

# 14. Dependency Policy

Dependencies should be kept to an absolute minimum.

Before introducing a dependency:

1. Verify that existing project tools cannot solve the problem.
2. Obtain explicit approval.

Dependencies must never be introduced merely for convenience.

---

# 15. Secrets Policy

Secrets must never be stored inside the repository.

Examples include:

- SSH keys;
- GPG keys;
- API keys;
- tokens;
- passwords;
- `.env` files.

Configuration for secret management may exist.

Secrets themselves may not.

The implementation of secret management may be planned but has not yet been defined.

Until then, secret management remains outside the scope of this repository.

---

# 16. Definition of Done

A task is considered completed only when **all** of the following conditions are satisfied.

---

## Implementation

- The requested functionality has been implemented.
- The implementation follows the project architecture.
- The implementation follows all project rules.

---

## Validation

- The implementation has been verified.
- No known errors remain.
- The repository remains in a working state.

---

## Documentation

- Documentation has been updated.
- Both language versions have been updated.
- Both versions preserve the same meaning.
- **AGENTS.md / AGENTS.ru.md** remain full-volume (not condensed).

---

## Roadmap

- The completed task has been marked in the Roadmap.
- Project State has been updated if required.

---

## Version Control

- The task ends with a Git commit.
- Every completed logical task must have its own commit.

If any requirement above is not satisfied, the task is considered incomplete.

---

# 17. Idempotency

Every build and configuration process in this repository must be idempotent.

Running the same build multiple times must never:

- create duplicate data;
- corrupt existing configuration;
- produce an inconsistent state;
- require manual cleanup.

Repeated execution must always result in one of the following:

- no changes because the desired state has already been reached;
- safe updates required to reach the desired state.

Idempotency is a mandatory requirement for every build process in this repository.

---

# 18. Decision Rules

Whenever a decision must be made, the following priority order applies.

Priority 1

AGENTS.md

Priority 2

Repository documentation

Priority 3

Existing project implementation

Priority 4

Repository owner

Conversation history must never override AGENTS.md.

If information conflicts, AGENTS.md always has priority.

---

# 19. Error Handling Policy

Build and implementation scripts must fail predictably.

The following are prohibited:

- silent failures;
- hidden failures;
- ignored errors.

---

## Error Reporting

Errors should clearly describe:

- what failed;
- where it failed;
- possible reason;
- possible resolution.

---

## Logging

Important operations should produce readable logs.

Logs should simplify troubleshooting.

Logs must never replace clear terminal output.

---

# 20. Coding Standards

The project intentionally follows conservative coding standards.

---

## Swift Conventions

- Follow Swift Naming Guidelines
- Prefer value types over reference types
- Use explicit error types
- Prefer optional chaining over forced unwrapping
- Use result builders for dynamic UI

---

## SwiftUI Conventions

- Use View protocol for reusable components
- Use EnvironmentValues for shared state
- Use Binding for two-way binding
- Use @StateObject for owned objects
- Prefer composition over inheritance

---

## Service Layer

- Services should be testable
- Services should not depend on UI
- Services should use Combine for async operations
- Services should handle errors explicitly

---

## Naming

Use descriptive names.

Avoid unnecessary abbreviations.

Good examples:

```swift
LabelCanvasState.swift
NiimbotBluetoothClient.swift
ImagePostProcessor.swift
```

Poor examples:

```swift
State.swift
Client.swift
Process.swift
```

---

## Single Responsibility

Each file should perform one logical task.

Large files should be split into smaller files.

---

## Readability

Readable code is preferred over compact code.

Avoid unnecessary complexity.

---

# 21. Project State

## Architecture

Status:

**Frozen** (v1.0: native SwiftUI, no Fabric.js)

---

## Repository

Status:

**Phase 5 in progress** (Template Management)

---

## Documentation

Status:

**Current** (AGENTS EN+RU full volume v1.0, README, Roadmap)

---

## Implementation

Status:

**Phase 4 complete** (Label Editor)

**Phase 3 complete** (Printer Connection)

**Phase 2 complete** (Xcode Project Setup)

**Phase 1 complete** (Repository Foundation)

---

# 22. Roadmap

Tasks should normally be completed sequentially.

Changing the implementation order requires explicit approval.

---

## Phase 1 — Repository Foundation

- [x] Create repository
- [x] Create repository structure
- [x] Create LICENSE
- [x] Create README.md
- [x] Create README.ru.md
- [x] Create AGENTS.md
- [x] Initialize Git

---

## Phase 2 — Xcode Project Setup

- [ ] Create Xcode project with SwiftUI
- [ ] Configure Info.plist (Bluetooth, Serial permissions)
- [ ] Create asset catalog
- [ ] Configure signing and capabilities
- [ ] Create basic app entry point

---

## Phase 3 — Printer Connection

- [x] NiimbotAbstractClient base class
- [x] NiimbotBluetoothClient (CoreBluetooth)
- [x] NiimbotSerialClient (NSLocalSocket for USB)
- [x] PrinterInfo model
- [x] PrinterConnectionStore ViewModel
- [x] Updated PrinterConnectorView with connection state
- [x] NiimbotCommands definitions
- [x] ZPLGenerator implementation
- [x] ObjectType and LabelObject models
- [x] All object controls (Text, QR, Barcode, Image, Shape)
- [x] LabelPropsEditor
- [x] ObjectPicker

**Status: Phase 3 complete**

---

## Phase 4 — Label Editor (Native SwiftUI)

- [x] SwiftUI Canvas container (LabelCanvasState, LabelCanvasView)
- [x] Object picker (text, QR, barcode, image, shape)
- [x] Text controls (font, size, color, alignment)
- [x] QR Code controls
- [x] Barcode controls
- [x] Image controls
- [x] Shape controls
- [x] Object actions (delete, clone, move)
- [x] Label properties editor

---

## Phase 5 — Template Management

- [x] ExportedLabelTemplate model
- [x] LabelStorage service
- [x] Save label function
- [x] Load label function
- [x] SavedLabelsView
- [ ] Import label function

---

## Phase 6 — Print Preview

- [x] ZPLGenerator
- [x] ImagePostProcessor
- [x] PrintTask model
- [x] PrintPreviewView
- [x] Print parameters (quantity, density, speed)
- [x] Print execution

---

## Phase 7 — CSV Support

- [x] CsvParams model
- [x] CsvParser
- [x] Variable interpolation
- [ ] Batch print support

---

## Phase 8 — User Fonts and Icons

- [ ] UserFont model
- [ ] UserIcon model
- [ ] FontManager
- [ ] Font loading
- [ ] Font storage
- [ ] Font picker UI
- [ ] Icon storage
- [ ] Icon picker UI

---

## Phase 9 — Settings

- [ ] AppConfig model
- [ ] ConfigStore
- [ ] SettingsView
- [ ] About screen

---

## Phase 10 — Testing and Optimization

- [ ] Unit tests
- [ ] UI tests
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] UI polish

---

# 23. Mutable Sections

The following sections may be updated automatically by AI agents:

- Project State
- Roadmap
- Task completion status
- Document Version (only after approval)

All other sections are immutable and require explicit approval from the repository owner.

Updating a mutable section must **not** involve compressing or truncating AGENTS.md / AGENTS.ru.md as a whole.

---

# 24. Final Rules

Every AI agent working on this repository must follow these rules without exception.

1. Read AGENTS.md before starting any work.
2. Follow AGENTS.md exactly.
3. Never guess.
4. Ask when information is missing.
5. Never redesign the project.
6. Never replace approved technologies.
7. Never introduce new dependencies without approval.
8. Never perform unrelated work.
9. Never optimize without permission.
10. Never refactor without approval.
11. Always update documentation.
12. Always keep English and Russian documentation synchronized while preserving meaning.
13. Always update the Roadmap after completing a task.
14. Always update the Project State when necessary.
15. Every completed logical task must end with a Git commit.
16. The repository must remain in a working state after every commit.
17. When reviewing or refactoring, always analyze the project before proposing changes.
18. If multiple valid solutions exist, stop and ask the repository owner.
19. If a rule conflicts with personal preference, the rule always wins.
20. If AGENTS.md conflicts with conversation history, AGENTS.md always wins.
21. The objective of this project is not to write clever code, but to build a stable, reproducible, maintainable and easily testable iOS application.
22. **Never** replace AGENTS.md or AGENTS.ru.md with a condensed or abbreviated version; keep full volume; actualize only with **explicit owner approval** for non-mutable content.

---

# End of Document
