# Implementation Plan

Полная реализация оставшихся фаз проекта: импорт JSON шаблонов, пакетная печать, панель настроек, тестирование и оптимизация

## Phase 5 - Template Import

- [x] Implement JSON label import from file
- [x] Create ImportLabelView with file picker
- [x] Add JSON validation and error handling
- [x] Test import with existing exported templates

## Phase 6 - Print Preview (complete)

- [x] Verify ZPLGenerator output
- [x] Implement print preview rendering
- [x] Add print parameters UI
- [x] Implement print execution flow

## Phase 7 - CSV Batch Print

- [ ] Extend CsvParams to support batch mode
- [ ] Implement variable population from CSV rows
- [ ] Add CSV batch print UI
- [ ] Implement batch print execution

## Phase 9 - Settings

- [x] Create AppConfig model (language, default printer, units)
- [x] Implement ConfigStore with UserDefaults persistence
- [x] Create SettingsView with all config options
- [x] Add About screen with app version

## Phase 10 - Testing and Polish

- [x] Write unit tests for Services layer
- [x] Write unit tests for Models layer
- [x] Create UI test scenarios
- [x] Fix identified bugs
- [x] Optimize performance (memory, rendering)
- [x] UI polish and consistency review