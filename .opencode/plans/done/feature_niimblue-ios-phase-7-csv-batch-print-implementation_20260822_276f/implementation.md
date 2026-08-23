# Implementation Plan

Реализация CSV Batch Print: парсинг CSV, импорта данных в этикетки, пакетная печать

## CSV Parser

- [x] CsvParser - парсинг CSV файлов
- [x] CsvParser - подстановка переменных

## CSV Import UI

- [x] CsvImportView с file picker
- [x] CsvBatchPrintSheet для выбора количества записей
- [x] CsvVariableEditor для настройки переменных

## Integration

- [x] Подключить CsvImportView в SavedLabelsView
- [x] Реализовать importCSVFiles функцию