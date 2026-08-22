# Specifications

Реализация CSV Batch Print - импорт данных из CSV файлов и пакетная печать этикеток

## Functional Requirements

- CSV Import - импорт данных из CSV файлов в этикетки
- Batch Print - выбор количества записей для печати
- Variable Substitution - подстановка переменных из CSV в этикетки

## Non-Functional Requirements

- Поддержка мульти-файлов CSV
- Обработка ошибок парсинга
- Интерфейс с предпросмотром

## Acceptance Criteria

- Файл CSV успешно импортируется
- Пользователь может выбрать количество записей
- Переменные из CSV подставляются корректно

## Out of Scope

- Расширенная валидация CSV
- Bulk импорт в LabelStorage