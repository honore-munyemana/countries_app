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

## 🏛️ Project Architecture

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

