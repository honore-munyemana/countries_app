import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/presentation/screens/home_screen.dart';
import 'src/logic/cubits/countries_cubit.dart';
import 'src/data/services/country_service.dart';
import 'src/data/services/favorites_service.dart';
import 'src/logic/cubits/favorites_cubit.dart';
import 'src/logic/cubits/theme_cubit.dart';
import 'src/data/services/theme_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CountriesCubit(CountriesService())..loadCountries(),
        ),
        BlocProvider(
          create: (_) => FavoritesCubit(FavoritesService())..loadFavorites(),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(ThemeService())..loadTheme(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(centerTitle: true),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(centerTitle: true),
            ),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
