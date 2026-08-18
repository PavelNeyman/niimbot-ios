# NiimBlue iOS - Roadmap

## 📋 Обзор

Этот документ содержит подробный план разработки нативного iOS приложения NiimBlue. Каждый этап включает технические детали, зависимости и ожидаемый результат.

---

## 🎯 Финальные цели

1. **Поддержка CoreBluetooth** для подключения к NIIMBOT принтерам через BLE
2. **Поддержка NSLocalSocket/USB** для подключения через USB
3. **Визуальный редактор этикеток** — полностью нативный SwiftUI
4. **Сохранение/загрузка шаблонов** в формате JSON
5. **Предварительный просмотр печати** с пост-обработкой
6. **Пользовательские шрифты** и иконки
7. **Share Extension** для интеграции с iOS

---

## 📅 Roadmap по фазам

### **Фаза 1: Базовая инфраструктура** (2-3 недели)

#### Цель
Создать основу проекта, настроить Xcode, разрешения и базовые экраны.

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 1.1 | Создание Xcode проекта | SwiftUI проект, Info.plist | - |
| 1.2 | Настройка разрешений | NSBluetoothPeripheralUsageDescription, NSSerialUsageDescription, UIBackgroundModes | - |
| 1.3 | Базовые экраны | MainPageView, PrinterConnectorView, LabelDesignerView, PrintPreviewView, SettingsView, SavedLabelsView | SwiftUI |
| 1.4 | Asset catalog | Assets.xcassets, Localizable.strings | - |

#### Результат
- Рабочий Xcode проект с базовой структурой
- Настроенные разрешения для Bluetooth и Serial
- 6 основных экранов приложения

#### Файлы для создания

```
NiimBlueiOS/
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
│   └── Models/
│       └── ...
```

---

### **Фаза 2: Подключение к принтеру** (3-4 недели)

#### Цель
Реализовать нативный CoreBluetooth клиент для связи с NIIMBOT принтерами.

#### Архитектура CoreBluetooth клиента

```
┌─────────────────────────────────────────────────────────┐
│                  NiimbotBluetoothClient                 │
├─────────────────────────────────────────────────────────┤
│  CoreBluetooth Stack                                    │
│  ┌───────────────────────────────────────────────────┐  │
│  │   CBCentralManager                                 │  │
│  │   └─> Discover Services (0x18FE)                  │  │
│  │         └─> Discover Characteristics               │  │
│  │               ├─> Write (Command Char)             │  │
│  │               └─> Read (Response Char)            │  │  │
│  └───────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────┤
│  Abstraction Layer                                      │
│  ├─> Printer Commands (ZPL, Status, etc.)              │
│  ├─> Heartbeat Mechanism                               │
│  ├─> RFID Commands                                     │
│  └─> Firmware Update                                   │
├─────────────────────────────────────────────────────────┤
│  Event System                                           │
│  ├─> onConnect / onDisconnect                          │
│  ├─> onPrinterInfoFetched                              │
│  ├─> onHeartbeat                                       │
│  └─> onError                                           │
└─────────────────────────────────────────────────────────┘
```

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 2.1 | NiimbotBluetoothClient | CoreBluetooth клиент | - |
| 2.2 | GATT Service discovery | Service 0x18FE, Characteristics | 2.1 |
| 2.3 | Command/Response handlers | Write/Read handlers | 2.1 |
| 2.4 | Heartbeat implementation | Periodic ping mechanism | 2.1 |
| 2.5 | PrinterInfo fetching | Get device info | 2.1 |
| 2.6 | NiimbotSerialClient | NSLocalSocket для USB | - |
| 2.7 | Connection state store | UserDefaults + Observable | 2.1, 2.6 |

#### Ключевые команды NIIMBOT

```swift
// Пример структуры команд
enum CommandId: UInt16 {
    case GetDeviceInformation = 0x0001
    case PrintZPL = 0x0002
    case GetStatus = 0x0003
    case Heartbeat = 0x0004
    case SetSound = 0x0005
    // ... полный список из NiimBlueLib
}
```

#### Результат
- Рабочий CoreBluetooth клиент
- Рабочий Serial клиент (USB)
- Хранилище состояния подключения

#### Файлы для создания

```
NiimBlueiOS/
├── NiimBlueiOS/
│   ├── Services/
│   │   ├── NiimbotBluetoothClient.swift
│   │   ├── NiimbotSerialClient.swift
│   │   └── NiimbotAbstractClient.swift
│   ├── Models/
│   │   ├── PrinterInfo.swift
│   │   ├── PrinterModelMeta.swift
│   │   └── HeartbeatData.swift
│   └── ViewModels/
│       └── PrinterConnectionStore.swift
```

---

### **Фаза 3: Визуальный редактор этикеток** (6-8 недель)

#### Цель
Реализовать нативный SwiftUI редактор этикеток с поддержкой множественных объектов.

#### Архитектура редактора

```
┌─────────────────────────────────────────────────────────┐
│                  LabelDesignerView                      │
├─────────────────────────────────────────────────────────┤
│  SwiftUI Canvas Layer                                    │
│  ┌───────────────────────────────────────────────────┐  │
│  │           Native SwiftUI Canvas                    │  │
│  │   ├─> Text Objects                                 │  │
│  │   ├─> QR Code Objects                              │  │
│  │   ├─> Barcode Objects                              │  │
│  │   ├─> Image Objects                                │  │
│  │   ├─> Shape Objects (Circle, Rect, Line)           │  │
│  │   └─> Image from URL                               │  │
│  └───────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────┤
│  Controls Layer (SwiftUI)                               │
│  ├─> Object Picker                                      │
│  ├─> Parameter Controls (по типу объекта)               │
│  ├─> Label Properties (размеры, форма)                  │
│  ├─> Actions (Delete, Clone, Move)                     │
│  └─> CSV Controls                                       │
├─────────────────────────────────────────────────────────┤
│  State Management                                       │
│  └─> LabelCanvasState (Observable)                     │
└─────────────────────────────────────────────────────────┘
```

#### Объекты редактора

| Тип | Описание | Параметры |
|-----|----------|-----------|
| Text | Текстовый блок | Шрифт, размер, цвет, выравнивание, переменные |
| QR Code | QR код | Текст, размер, коррекция ошибок, отступы |
| Barcode | Штрихкод | Тип, текст, размер, отступы |
| Image | Изображение | URL изображения, размер, положение |
| Shape | Фигура | Тип (круг, прямоугольник), цвет, размер |

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 3.1 | SwiftUI Canvas container | Native SwiftUI canvas | - |
| 3.2 | Object type selection | ObjectPicker компонент | 3.1 |
| 3.3 | Text controls | TextParamsControls | 3.1 |
| 3.4 | QR Code controls | QRCodeParamsControls | 3.1 |
| 3.5 | Barcode controls | BarcodeParamsControls | 3.1 |
| 3.6 | Image controls | ImageParamsControls | 3.1 |
| 3.7 | Shape controls | ShapeParamsControls | 3.1 |
| 3.8 | Label properties | LabelPropsEditor (размеры, форма) | 3.1 |
| 3.9 | Object actions | Delete, Clone, Move | 3.1 |
| 3.10 | Canvas state persistence | LabelCanvasState model | 3.1-3.9 |

#### Структура LabelCanvasState

```swift
struct LabelCanvasState: Codable {
    let version: String
    let objects: [LabelObject]
    
    struct LabelObject: Codable, Identifiable {
        let id: UUID
        let type: ObjectType
        let x: Double
        let y: Double
        let width: Double
        let height: Double
        let rotation: Double
        // ... дополнительные параметры в зависимости от типа
    }
}
```

#### Результат
- Рабочий нативный редактор этикеток SwiftUI
- Поддержка всех типов объектов
- Управление объектами (добавление, удаление, дублирование, перемещение)

#### Файлы для создания

```
NiimBlueiOS/
├── NiimBlueiOS/
│   ├── Views/
│   │   └── LabelDesignerView.swift
│   ├── Models/
│   │   └── LabelCanvasState.swift
│   └── Controls/
│       ├── ObjectPicker.swift
│       ├── TextParamsControls.swift
│       ├── QRCodeParamsControls.swift
│       ├── BarcodeParamsControls.swift
│       ├── ImageParamsControls.swift
│       ├── ShapeParamsControls.swift
│       └── LabelPropsEditor.swift
```

---

### **Фаза 4: Сохранение и загрузка шаблонов** (2-3 недели)

#### Цель
Реализовать сохранение и загрузку шаблонов в формате JSON.

#### Формат сохранения

```json
{
  "canvas": {
    "version": "1.0.0",
    "objects": [
      {
        "id": "uuid-1",
        "type": "text",
        "left": 0,
        "top": 0,
        "width": 100,
        "height": 20,
        "content": "Hello World",
        "fontSize": 16,
        "fontFamily": "Arial",
        "color": "#000000"
      }
    ]
  },
  "label": {
    "width": 100,
    "height": 50,
    "unit": "mm",
    "dpmm": 203,
    "printDirection": "left",
    "shape": "rect",
    "split": "none",
    "tailPos": "right"
  },
  "title": "My Label",
  "timestamp": 1234567890,
  "csv": {
    "data": "id,name,value\n1,Item1,100"
  }
}
```

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 4.1 | ExportedLabelTemplate model | JSON структура | 3.10 |
| 4.2 | LabelStorage service | FileManager operations | 4.1 |
| 4.3 | Save label function | Экспорт в JSON | 4.1, 4.2 |
| 4.4 | Load label function | Импорт из JSON | 4.1, 4.2 |
| 4.5 | SavedLabelsView | Список сохраненных шаблонов | 4.1, 4.3, 4.4 |
| 4.6 | Import label function | Импорт из файла | 4.1, 4.2 |

#### Результат
- Возможность сохранять шаблоны
- Возможность загружать сохраненные шаблоны
- Список всех сохраненных шаблонов

#### Файлы для создания

```
NiimBlueiOS/
├── NiimBlueiOS/
│   ├── Models/
│   │   └── ExportedLabelTemplate.swift
│   ├── Services/
│   │   └── LabelStorage.swift
│   └── Views/
│       └── SavedLabelsView.swift
```

---

### **Фаза 5: Предварительный просмотр печати** (3-4 недели)

#### Цель
Реализовать генерацию ZPL и предпросмотр печати с пост-обработкой.

#### Пост-обработка изображений

```swift
struct ImagePostProcessor {
    static func threshold(image: CGImage) -> CGImage
    static func dither(image: CGImage, method: DitherMethod) -> CGImage
    static func bayer(image: CGImage) -> CGImage
    static func invert(image: CGImage) -> CGImage
}

enum DitherMethod {
    case atkinson
    case stork
    case siemens
}
```

#### ZPL генерация

```swift
class ZPLGenerator {
    static func generate(label: ExportedLabelTemplate) -> String {
        var zpl = ""
        
        // Header
        zpl += "^XA\n"
        zpl += "^MT2\n"
        zpl += "^PW\(label.width)\n"
        zpl += "^PH\(label.height)\n"
        
        // Objects
        for object in label.canvas.objects {
            switch object.type {
            case .text:
                zpl += generateTextZPL(object)
            case .qrcode:
                zpl += generateQRCodeZPL(object)
            case .barcode:
                zpl += generateBarcodeZPL(object)
            case .image:
                zpl += generateImageZPL(object)
            // ...
            }
        }
        
        zpl += "^XZ\n"
        return zpl
    }
}
```

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 5.1 | ImagePostProcessor | Пост-обработка изображений | - |
| 5.2 | ZPLGenerator | Генерация ZPL из canvas | 3.10 |
| 5.3 | PrintTask model | Параметры печати | 5.1, 5.2 |
| 5.4 | PrintPreviewView | UI для предпросмотра | 5.1, 5.2, 5.3 |
| 5.5 | Print task selection | Выбор типа задачи | 5.3 |
| 5.6 | Print parameters | Quantity, density, speed, offset | 5.3 |
| 5.7 | Print execution | Отправка ZPL на принтер | 2.1, 5.2 |

#### Результат
- Генерация ZPL из canvas
- Предпросмотр с пост-обработкой
- Выбор параметров печати
- Отправка печати на принтер

#### Файлы для создания

```
NiimBlueiOS/
├── NiimBlueiOS/
│   ├── Services/
│   │   ├── ImagePostProcessor.swift
│   │   └── ZPLGenerator.swift
│   ├── Models/
│   │   └── PrintTask.swift
│   └── Views/
│       └── PrintPreviewView.swift
```

---

### **Фаза 6: CSV и динамические данные** (2-3 недели)

#### Цель
Реализовать поддержку CSV данных для динамической генерации этикеток.

#### CSV формат

```csv
id,name,price,quantity
1,Product1,100,50
2,Product2,200,30
```

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 6.1 | CsvParams model | CSV структура | - |
| 6.2 | CsvParser | Парсинг CSV | 6.1 |
| 6.3 | Variable interpolation | Замена переменных | 6.1, 6.2 |
| 6.4 | CsvControlView | UI для CSV | 6.1, 6.2 |
| 6.5 | Batch print support | Печать нескольких этикеток | 6.2, 6.3 |

#### Результат
- Парсинг CSV данных
- Замена переменных в текстах
- Печать нескольких этикеток из CSV

#### Файлы для создания

```
NiimBlueiOS/
├── NiimBlueiOS/
│   ├── Models/
│   │   └── CsvParams.swift
│   ├── Services/
│   │   └── CsvParser.swift
│   └── Views/
│       └── CsvControlView.swift
```

---

### **Фаза 7: Пользовательские шрифты и иконки** (2 недели)

#### Цель
Поддержка пользовательских шрифтов и иконок.

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 7.1 | UserFont model | Модель пользовательского шрифта | - |
| 7.2 | UserIcon model | Модель иконки | - |
| 7.3 | FontManager | Управление шрифтами | 7.1 |
| 7.4 | Font loading | Загрузка из base64 | 7.2, 7.3 |
| 7.5 | UserFontStorage | Хранилище шрифтов | 7.1, 7.3 |
| 7.6 | UserIconStorage | Хранилище иконок | 7.2 |
| 7.7 | Font picker UI | Выбор шрифтов | 7.5 |
| 7.8 | Icon picker UI | Выбор иконок | 7.6 |

#### Структура пользовательского шрифта

```swift
struct UserFont: Codable, Identifiable {
    let id: UUID
    let gzippedDataB64: String
    let family: String
    let mimeType: String
}
```

#### Результат
- Загрузка пользовательских шрифтов
- Выбор шрифтов в редакторе
- Хранение шрифтов в приложении

#### Файлы для создания

```
NiimBlueiOS/
├── NiimBlueiOS/
│   ├── Models/
│   │   ├── UserFont.swift
│   │   └── UserIcon.swift
│   ├── Services/
│   │   ├── FontManager.swift
│   │   ├── FontStorage.swift
│   │   └── IconStorage.swift
│   └── Views/
│       ├── FontPicker.swift
│       └── IconPicker.swift
```

---

### **Фаза 8: Share Extensions** (1-2 недели)

#### Цель
Интеграция с Share Extension для печати через Shortcuts.

#### Архитектура Share Extension

```
┌─────────────────────────────────────────────────────────┐
│                 Share Extension                         │
├─────────────────────────────────────────────────────────┤
│  ShareViewController                                    │
│  ├─> Present NiimBlue app                              │
│  ├─> Receive shared data                               │
│  └─> Print label                                       │
└─────────────────────────────────────────────────────────┘
```

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 8.1 | Create Share Extension | NSExtension пункт | - |
| 8.2 | ShareViewController | Основной контроллер | 8.1 |
| 8.3 | Data exchange | Передача данных в NiimBlue | 8.1, 8.2 |
| 8.4 | Print from share | Печать через NiimBlue | 8.3 |

#### Результат
- Share Extension для печати
- Интеграция с Shortcuts

#### Файлы для создания

```
NiimBlueiOS/
└── NiimBlueShareExtension/
    └── ShareViewController.swift
```

---

### **Фаза 9: Настройки и конфигурация** (1-2 недели)

#### Цель
Реализовать настройки приложения.

#### Конфигурация

```swift
struct AppConfig: Codable {
    var fitMode: FitMode = .ratioMin
    var pageDelay: TimeInterval?
    var iconListMode: IconListMode = .both
    var packetIntervalMs: Int?
}

enum FitMode {
    case stretch
    case ratioMin
    case ratioMax
}

enum IconListMode {
    case user
    case pack
    case both
}
```

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 9.1 | AppConfig model | Модель конфигурации | - |
| 9.2 | ConfigStore | Хранилище настроек | 9.1 |
| 9.3 | SettingsView | UI настроек | 9.1, 9.2 |
| 9.4 | About screen | Информация о приложении | - |

#### Результат
- Настройки приложения
- Информация о приложении

#### Файлы для создания

```
NiimBlueiOS/
├── NiimBlueiOS/
│   ├── Models/
│   │   └── AppConfig.swift
│   ├── ViewModels/
│   │   └── ConfigStore.swift
│   └── Views/
│       └── SettingsView.swift
```

---

### **Фаза 10: Тестирование и оптимизация** (2-3 недели)

#### Цель
Тестирование, исправление багов и оптимизация.

#### Задачи

| # | Задача | Детали | Зависимости |
|---|--------|--------|-------------|
| 10.1 | Unit tests | Тесты для моделей | - |
| 10.2 | UI tests | Тесты для UI | - |
| 10.3 | Bug fixes | Исправление багов | 10.1, 10.2 |
| 10.4 | Performance optimization | Оптимизация памяти | - |
| 10.5 | Bluetooth optimization | Оптимизация BLE | - |
| 10.6 | UI polish | Улучшение UX | - |

#### Результат
- Протестированное приложение
- Исправленные баги
- Оптимизированная производительность

---

## 📊 Статус разработки

### Текущая фаза: Фаза 1 (Базовая инфраструктура)

### Выполнено:
- [x] Создание директории проекта
- [x] Планирование архитектуры
- [x] Создание AGENTS.md
- [x] Создание ROADMAP.md

### В процессе:
- [ ] Инициализация Xcode проекта
- [ ] Настройка Info.plist
- [ ] Создание базовых экранов

### Осталось:
- [ ] Фаза 2: Подключение к принтеру
- [ ] Фаза 3: Визуальный редактор
- [ ] Фаза 4: Сохранение шаблонов
- [ ] Фаза 5: Предварительный просмотр
- [ ] Фаза 6: CSV данные
- [ ] Фаза 7: Пользовательские шрифты
- [ ] Фаза 8: Share Extension
- [ ] Фаза 9: Настройки
- [ ] Фаза 10: Тестирование

---

## 🚀 Следующие шаги

1. **Создать Xcode проект** (Фаза 1)
2. **Настроить Info.plist** с разрешениями
3. **Создать базовые экраны** SwiftUI

---

## 📞 Контакты

При возникновении вопросов:
1. Сначала прочитайте AGENTS.md и ROADMAP.md
2. Если вопрос не решён — спросите у пользователя
3. Не принимайте решения по архитектуре без согласования
