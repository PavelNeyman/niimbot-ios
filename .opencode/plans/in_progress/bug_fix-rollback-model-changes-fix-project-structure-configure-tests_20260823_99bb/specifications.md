# Specifications

Исправить проект после изменений слабой модели, восстановить оригинальную структуру, добавить поддержку тестов

## Functional Requirements

- Откат всех внесённых изменений к HEAD
- Удалить временные файлы проекта
- Удалить копию AppDelegate.swift из корня проекта
- Закоммитьть изменения с правильным сообщением
- Выполнить успешную сборку проекта
- Добавить тестовые файлы в project.pbxproj
- Добавить тестовый target для NiimBlueiOSTests
- Добавить конфигурации сборки для тестов
- Выполнить успешный запуск тестов

## Non-Functional Requirements

- Соблюдение оригинальной структуры проекта
- Сохранение оригинальных bundle identifiers
- Не вносить изменения в AGENTS.md и AGENTS.ru.md
- Не изменять DEVELOPMENT_TEAM в build settings
- Не изменять sourceTree в PBXGroup
- Не удалять ключи из Info.plist

## Acceptance Criteria

- xcodebuild -scheme NiimBlueiOS -sdk iphonesimulator -configuration Debug build завершается успешно
- git status показывает только AppDelegate.swift как изменённый файл
- git log показывает коммит с сообщением о восстановлении
- xcodebuild test -scheme NiimBlueiOS запускается без ошибок
- Тестовый target существует в project.pbxproj
- Все тестовые файлы добавлены в project.pbxproj

## Out of Scope

- Изменение AGENTS.md или AGENTS.ru.md
- Изменение bundle identifier
- Добавление новых функций приложения
- Рефакторинг кода приложения
- Изменение подписи и Development Team