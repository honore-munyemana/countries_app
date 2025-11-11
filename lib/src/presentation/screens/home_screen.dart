import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/countries_cubit.dart';
import '../../logic/cubits/countries_state.dart';
import '../../logic/cubits/favorites_cubit.dart';
import '../../logic/cubits/theme_cubit.dart';
import '../../data/models/country_model.dart';
import 'country_detail_screen.dart';
import 'favorites_screen.dart';
import '../widgets/shimmer_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CountriesCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? 'Switch to light' : 'Switch to dark',
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => context.read<ThemeCubit>().toggle(),
                onLongPress: () => context.read<ThemeCubit>().setTheme(ThemeMode.system),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a country',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => cubit.searchCountries(value),
            ),
          ),
          Expanded(
            child: BlocBuilder<CountriesCubit, CountriesState>(
              builder: (context, state) {
                if (state is CountriesLoading) {
                  return const ShimmerList();
                }
                if (state is CountriesLoaded) {
                  if (state.countries.isEmpty) {
                    return _EmptyState(onRetry: cubit.loadCountries);
                  }
                  return RefreshIndicator(
                    onRefresh: () => cubit.loadCountries(),
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, favState) {
                        return ListView.separated(
                          itemCount: state.countries.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final c = state.countries[i];
                            final isFav = context.read<FavoritesCubit>().isFavoriteSync(c.cca2);
                            return _CountryListItem(
                              country: c,
                              isFavorite: isFav,
                              onToggleFavorite: () => context.read<FavoritesCubit>().toggleFavorite(c.cca2),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => CountryDetailScreen(countryName: c.name, cca2: c.cca2, flagUrl: c.flag),
                                ));
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                if (state is CountriesError) {
                  return _ErrorState(message: state.message, onRetry: cubit.loadCountries);
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryListItem extends StatelessWidget {
  final Country country;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;
  const _CountryListItem({
    required this.country,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

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
      subtitle: Text(country.region),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        color: isFavorite ? Theme.of(context).colorScheme.primary : null,
        onPressed: onToggleFavorite,
      ),
      onTap: onTap,
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public_off, size: 48),
            const SizedBox(height: 12),
            const Text('No countries found'),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Reload')),
          ],
        ),
      ),
    );
  }
}
