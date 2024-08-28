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

## HAY
![SimulatorScreenRecording-iPhone15Pro-2024-08-28at12 23 16-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/e17a6d87-2feb-46d8-b3c2-d085887d19be) ![header-ezgif com-video-to-gif-converter-2](https://github.com/user-attachments/assets/0a38bdd0-3387-4e5c-8fb5-94d70f185218) ![main](https://github.com/katyamichal/HAY/assets/124366801/00a6ad54-585e-4ed7-8f39-abe59383c717)

## HAY Designer Details
![SimulatorScreenRecording-iPhone15Pro-2024-08-28at11 16 44-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/b98857d7-31fd-472e-802e-62f3554a1963)
## Favourite: список любимых/избранных товаров
![SimulatorScreenRecording-iPhone15Pro-2024-08-28at12 15 52-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/6c7127c5-3992-44aa-bbee-b915772a0eee)
## Личный кабинет
## Корзина
![RPReplay_Final1693321411-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/787f2282-43dd-4489-9cec-005ee5d8ef19)

  
