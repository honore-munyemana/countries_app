import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/country_service.dart';
import '../../data/models/country_model.dart';

abstract class CountryDetailState {}
class CountryDetailInitial extends CountryDetailState {}
class CountryDetailLoading extends CountryDetailState {}
class CountryDetailLoaded extends CountryDetailState {
  final CountryDetails country;
  CountryDetailLoaded(this.country);
}
class CountryDetailError extends CountryDetailState {
  final String message;
  CountryDetailError(this.message);
}

class CountryDetailCubit extends Cubit<CountryDetailState> {
  final CountriesService service;
  CountryDetailCubit(this.service) : super(CountryDetailInitial());

  Future<void> loadCountryDetail(String cca2) async {
    try {
      emit(CountryDetailLoading());
      final detail = await service.fetchCountryDetails(cca2);
      emit(CountryDetailLoaded(detail));
    } catch (e) {
      emit(CountryDetailError(e.toString()));
    }
  }
}
