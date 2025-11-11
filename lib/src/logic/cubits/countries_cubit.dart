import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/country_model.dart';
import '../../data/services/country_service.dart';
import 'countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final CountriesService service;
  List<Country> _allCountries = [];

  CountriesCubit(this.service) : super(CountriesInitial());

  Future<void> loadCountries() async {
    try {
      emit(CountriesLoading());
      final rawCountries = await service.fetchCountries();
      _allCountries = rawCountries.map<Country>((json) => Country.fromJson(json)).toList();
      emit(CountriesLoaded(_allCountries));
    } catch (e) {
      emit(CountriesError(e.toString()));
    }
  }

  void searchCountries(String query) {
    if (query.isEmpty) {
      emit(CountriesLoaded(_allCountries));
    } else {
      final filtered = _allCountries
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(CountriesLoaded(filtered));
    }
  }
}
