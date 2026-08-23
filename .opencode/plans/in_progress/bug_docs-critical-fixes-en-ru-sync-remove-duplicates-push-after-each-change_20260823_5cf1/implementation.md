# Implementation Plan

План состоит из 7 шагов, каждый шаг - отдельный коммит. Каждый шаг должен заканчиваться проверкой результата и отправкой на GitHub перед следующим шагом.

## Step 1: Проверка состояния тестов

- [x] Выполнить git ls-files | grep -i test, чтобы найти все файлы тестов в репозитории
- [x] Если тестов нет - добавить в AGENTS.md раздел Testing Policy с инструкцией по запуску
- [x] Если тесты есть - проверить их наличие в NiimBlueiOSTests/
- [x] Выполнить команду xcodebuild test -scheme NiimBlueiOS -destination platform=iOS Simulator,name=iPhone 15 локально
- [x] Если xcodebuild не работает - запросить установку Xcode Command Line Tools через: xcode-select --install
- [x] Задокументировать результат проверки тестов в отдельном файле NOTES.md

## Step 2: Исправление Phase 5 в AGENTS.ru.md

- [x] Прочитать AGENTS.ru.md и найти строку Phase 5 Import label function
- [x] Использовать edit для изменения [ ] Import label function на [x] Import label function в строке около 1072
- [x] Выполнить git add AGENTS.ru.md && git commit -m 'docs: Исправить статус Phase 5 Import label function в AGENTS.ru.md [x]',
- [x] Выполнить git push origin master и проверить успех
- [x] Выполнить git fetch origin-step2 && git log --oneline -5 для подтверждения синхронизации

## Step 3: Исправление Phase 7 в AGENTS.ru.md

- [x] Прочитать AGENTS.ru.md и найти строку Phase 7 Batch print support
- [x] Использовать edit для изменения [ ] Batch print support на [x] Batch print support в строке около 1094
- [x] Выполнить git add AGENTS.ru.md && git commit -m 'docs: Исправить статус Phase 7 Batch print support в AGENTS.ru.md [x]',
- [x] Выполнить git push origin master-step3 и проверить успех
- [x] Выполнить git fetch origin-step3 && git log --oneline -5 для подтверждения синхронизации

## Step 4: Удаление дублирующего блока Phase 10-11 в AGENTS.md

- [x] Прочитать AGENTS.md и найти дублирующий блок на строках 1135-1148
- [x] Использовать edit для удаления строки ## Phase 10 - Testing and Optimization (строка 1135)
- [x] Использовать edit для удаления всех строк дублирующего блока Phase 10 (строки 1136-1141)
- [x] Использовать edit для удаления строки --- (строка 1142)
- [x] Использовать edit для удаления строки ## Phase 11 - Final Polish and Deployment (строка 1143)
- [x] Использовать edit для удаления всех строк дублирующего блока Phase 11 (строки 1144-1149)
- [x] Выполнить git add AGENTS.md && git commit -m 'docs: Удалить дублирующий блок Phase 10-11 в AGENTS.md',
- [x] Выполнить git push origin master-step4 и проверить успех
- [x] Выполнить git fetch origin-step4 && git log --oneline -5 для подтверждения синхронизации

## Step 5: Синхронизация Project State разделов

- [x] Прочитать AGENTS.md раздел Project State (строки 953-967) и AGENTS.ru.md раздел Project State (строки 969-992)
- [x] Сравнить содержимое разделов Project State в обоих документах
- [x] Определить какие разделы отсутствуют в одном из документов (AGENTS.ru.md имеет дополнительные разделы Документация и Реализация)
- [x] Решить: либо удалить дублирующие разделы из AGENTS.ru.md, либо добавить разделы в AGENTS.md
- [x] Выполнить edit для синхронизации разделов Project State
- [x] Выполнить git add AGENTS.md AGENTS.ru.md && git commit -m 'docs: Синхронизировать разделы Project State в AGENTS.md и AGENTS.ru.md',
- [x] Выполнить git push origin master-step5 и проверить успех
- [x] Выполнить git fetch origin-step5 && git log --oneline -5 для подтверждения синхронизации

## Step 6: Проверка и синхронизация README.md и README.ru.md

- [x] Прочитать README.md и найти статусы фаз
- [x] Прочитать README.ru.md и найти статусы фаз
- [x] Сравнить статусы фаз в обоих документах
- [x] Выполнить edit для синхронизации статусов фаз в README.ru.md с AGENTS.md
- [x] Выполнить git add README.ru.md && git commit -m 'docs: Синхронизировать статусы фаз в README.ru.md',
- [x] Выполнить git push origin master-step6 и проверить успех
- [x] Выполнить git fetch origin-step6 && git log --oneline -5 для подтверждения синхронизации

## Step 7: Финальная валидация и документация

- [x] Выполнить grep для проверки, что все статусы [x] в AGENTS.md и AGENTS.ru.md синхронизированы
- [x] Проверить отсутствие дубликатов в AGENTS.md через grep -n ## Phase
- [x] Если тесты были найдены - выполнить их локально и задокументировать результат
- [~] Создать краткий отчет в CHANGELOG.md о выполненных исправлениях
- [ ] Выполнить git add . && git commit -m 'docs: Финальная валидация и отчет об исправлениях',
- [ ] Выполнить git push origin master-step7 и проверить успех