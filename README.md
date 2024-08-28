# HAY Project

## Описание
HAY Project — это iOS-приложение, разработанное для популярного датского бренда мебели и аксессуаров для дома [Hay](https://www.hay.dk). 

Приложение предлагает пользователям удобный и интуитивно понятный способ просмотра и покупки товаров бренда, вдохновленный современными трендами в UX/UI дизайне. 

Проект реализован с учетом современных практик разработки, а также предоставляет высокую степень модульности и расширяемости кода, что позволяет легко добавлять новый функционал и адаптировать приложение под изменяющиеся требования.

Основное внимание уделяется качеству пользовательского интерфейса, плавности анимаций и стабильности работы приложения.

### Статус проекта
Проект находится в стадии активного переписывания. В процессе разработки могут отсутствовать некоторые функции, анимации и элементы интерфейса. 

## API
Приложение использует моковое API.

## Технологии

**Хранение данных**:
- `Core Data` — локальное хранение данных (избранные товары и товары в корзине)
- `Keychain` — хранение данных о пользователе

**Сетевой слой**:
- `URLSession` — работа с сетью.
- Расширяемый и тестируемый сетевой сервис с использованием `async/await`
- Сообщение об ошибке при неудачной обработке
- Обработка отсутствия интернет-соединения с помощью `NetworkMonitor`

**Архитектура и паттерны**:
- `MVVM` + `Coordinator`
- `Singleton`
- `Flyweight`
- `Delegate`
- Сервис для синхронизации изменений в списке любимых товаров с применением паттерна `Observer`
- `Factory`
- `Decorator`

**Интерфейс**:
- `UIKit`.
- Все экраны организованы с использованием `UITabBarController` для удобной навигации между ними
- Кастомные UI-элементы, включая `растягивающийся Header` для `UITableView`, `UIButton(s)`, а также использование `UICollectionView` внутри ячеек `UITableView`
- `UICollectionViewCompositionalLayout`

**Анимации**:
- Нативная анимация `shimmering` при загрузке данных с сервера

**UX/UI**:
- Дизайн вдохновлен приложением Золотое Яблоко и веб-версией сайта HAY
- Все материалы принадлежат HAY и не предназначены для коммерческого использования

## HAY Tabs

# HAY
![SimulatorScreenRecording-iPhone15Pro-2024-08-28at19 28 44-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/bef192d3-d59e-4f92-966a-22719fd9bcf1)
![header-ezgif com-video-to-gif-converter-3](https://github.com/user-attachments/assets/3dafca5f-4763-440e-9ecf-6981d305300a) ![main](https://github.com/katyamichal/HAY/assets/124366801/00a6ad54-585e-4ed7-8f39-abe59383c717)

# HAY Designer Details
![SimulatorScreenRecording-iPhone15Pro-2024-08-28at19 51 06-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/2b7da14d-b961-4e0b-b50b-9ce44b040043)
# Favourite: список любимых/избранных товаров
![SimulatorScreenRecording-iPhone15Pro-2024-08-28at19 45 15-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/92572dcc-2437-43d9-b81d-18fc81ebf988)
![SimulatorScreenRecording-iPhone15Pro-2024-08-28at19 46 02-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/9514c08d-272e-4a9a-8e17-c14d9e4a9dce)

# Корзина
![RPReplay_Final1693321411-ezgif com-video-to-gif-converter-2](https://github.com/user-attachments/assets/54b2e02e-eaaa-4546-97da-7ed310ee78d5)
# Аккаунт


  
