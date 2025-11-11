import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/theme_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeService service;
  ThemeCubit(this.service) : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final mode = await service.loadThemeMode();
    emit(_fromString(mode));
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    await service.saveThemeMode(_toString(mode));
  }

  Future<void> toggle() async {
    // Toggle light <-> dark; hold long-press in UI for system if needed
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(next);
  }

  String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  ThemeMode _fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}


