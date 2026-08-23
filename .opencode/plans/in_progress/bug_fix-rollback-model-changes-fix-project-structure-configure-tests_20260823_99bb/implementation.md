# Implementation Plan

Откатить все изменения внесённые слабой моделью, восстановить оригинальную структуру проекта, удалить копию AppDelegate.swift из корня, добавить тестовый target для запуска тестов

## Шаг 1: Откат изменений

- [x] Откатить NiimBlueiOS.xcodeproj/project.pbxproj к HEAD
- [x] Откатить NiimBlueiOS/Info.plist к HEAD
- [x] Откатить NiimBlueiOS/NiimBlueiOS.entitlements к HEAD
- [x] Откатить .opencode/plans/done/... к HEAD

## Шаг 2: Очистка временных файлов

- [x] Удалить NiimBlueiOS.xcodeproj/project.xcworkspace/
- [x] Удалить NiimBlueiOS.xcodeproj/xcuserdata/
- [x] Удалить копию AppDelegate.swift из NiimBlueiOS/ (оставить только в Application/)

## Шаг 3: Проверка и коммит

- [x] Убедиться, что AppDelegate.swift существует в NiimBlueiOS/Application/
- [x] Закоммитьть изменения с сообщением о восстановлении структуры
- [x] Запушить изменения на origin/master

## Шаг 4: Валидация сборки

- [~] Выполнить xcodebuild -scheme NiimBlueiOS -sdk iphonesimulator -configuration Debug build
- [~] Проверить успешное завершение сборки

## Шаг 5: Настройка тестов

- [ ] Проверить наличие тестовых файлов в NiimBlueiOSTests/
- [ ] Добавить тестовые файлы в project.pbxproj (PBXFileReference, PBXBuildFile)
- [ ] Добавить тестовый target PBXNativeTarget для NiimBlueiOSTests
- [ ] Добавить конфигурации Debug/Release для тестов (XCBuildConfiguration)
- [ ] Добавить XCConfigurationList для тестового target
- [ ] Выполнить xcodebuild test -scheme NiimBlueiOS -destination 'platform=iOS Simulator,name=iPhone 17 Pro'