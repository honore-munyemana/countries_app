#  Countries Explorer App

A Flutter application that displays a list of countries, allows users to search, view details, and save favorites. The project uses modern Flutter architecture with **BLoC (Cubit)** state management and supports **light/dark theme switching** and **favorites persistence** using local storage.

---

##  Features

| Feature | Description |
|--------|-------------|
| Fetch Countries | Loads country data from REST Countries API (`https://restcountries.com/v3.1/all`) |
| Search | Real-time search by country name |
| Country Details | Shows country flag, capital, region, population and other info |
| Favorites | Users can mark countries as favorites and stored locally |
| Theme Mode | Switch between Light and Dark mode |
| Shimmer Loading | Smooth loading animation while fetching data |

---

##  Project Architecture

lib/

└── src/

├── data/

│ ├── models/

│ │ └── country_model.dart

│ └── services/

│ ├── country_service.dart

│ ├── favorites_service.dart

│ └── theme_service.dart

├── logic/

│ └── cubits/

│ ├── countries_cubit.dart

│ ├── country_detail_cubit.dart

│ ├── favorites_cubit.dart

│ └── theme_cubit.dart

└── presentation/

├── screens/

│ ├── home_screen.dart

│ ├── country_detail_screen.dart

│ └── favorites_screen.dart

└── widgets/

└── shimmer_list.dart

---

The project follows **Clean Architecture + BLoC** for scalable structure.

---

## 🛠️ Technologies & Tools Used

- **Flutter**: 3.x or later
- **Dart**: ≥2.17
- **State Management**: `flutter_bloc`
- **Local Persistence**: `SharedPreferences`
- **HTTP Networking**: `http` package
- **UI/UX Enhancements**: Shimmer loading, responsive layouts

---

##  How to Run the Project

### 1. **Clone the Repository**
```bash
git clone https://github.com/honore-munyemana/countries_app.git
cd countries_app
```
### 2. **Install Dependencies**
```
flutter pub get
```
### 3. Run the App

```
flutter run
```
##  Supported Platforms

| Platform                  | Status                               |
| ------------------------- | ------------------------------------ |
| Android                   | ✅ Fully tested                       |
| iOS                       | ⚠️ Runs, but requires macOS to build |
| Web                       | ✅ Works in Chrome                    |
| Windows/Linux/Mac Desktop | ✅ Flutter-supported desktop build    |

---

##  Developer

Name: Honore Munyemana
Email: honoremushya@gmail.com
GitHub: https://github.com/honore-munyemana


