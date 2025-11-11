import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/favorites_cubit.dart';
import '../../logic/cubits/countries_cubit.dart';
import '../../logic/cubits/countries_state.dart';
import '../../data/models/country_model.dart';
import 'country_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favState) {
          if (favState is FavoritesLoading || favState is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (favState is FavoritesError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 12),
                  Text(favState.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.read<FavoritesCubit>().loadFavorites(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final favorites = (favState as FavoritesLoaded).favoriteCca2Codes;

          return BlocBuilder<CountriesCubit, CountriesState>(
            builder: (context, countriesState) {
              if (countriesState is CountriesLoaded) {
                final favCountries = countriesState.countries.where((c) => favorites.contains(c.cca2)).toList();
                if (favCountries.isEmpty) {
                  return const _FavoritesEmpty();
                }
                return ListView.separated(
                  itemCount: favCountries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final c = favCountries[i];
                    return _FavoriteItem(
                      country: c,
                      onRemove: () => context.read<FavoritesCubit>().toggleFavorite(c.cca2),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CountryDetailScreen(countryName: c.name, cca2: c.cca2, flagUrl: c.flag),
                        ));
                      },
                    );
                  },
                );
              } else if (countriesState is CountriesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (countriesState is CountriesError) {
                return Center(child: Text(countriesState.message));
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}

class _FavoritesEmpty extends StatelessWidget {
  const _FavoritesEmpty();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.favorite_border, size: 48),
            SizedBox(height: 12),
            Text('No favorite countries yet'),
          ],
        ),
      ),
    );
  }
}

class _FavoriteItem extends StatelessWidget {
  final Country country;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  const _FavoriteItem({required this.country, required this.onRemove, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'flag_${country.cca2}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(country.flag, width: 56, height: 36, fit: BoxFit.cover),
        ),
      ),
      title: Text(country.name),
      subtitle: Text(country.capital.isNotEmpty ? country.capital : '—'),
      trailing: IconButton(
        icon: const Icon(Icons.favorite),
        color: Theme.of(context).colorScheme.primary,
        onPressed: onRemove,
        tooltip: 'Remove from favorites',
      ),
      onTap: onTap,
    );
  }
}

