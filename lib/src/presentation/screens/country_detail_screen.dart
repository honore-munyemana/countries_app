import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/country_detail_cubit.dart';
import '../../data/services/country_service.dart';
import '../../data/models/country_model.dart';

class CountryDetailScreen extends StatelessWidget {
  final String countryName;
  final String cca2;
  final String flagUrl;
  const CountryDetailScreen({super.key, required this.countryName, required this.cca2, required this.flagUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountryDetailCubit(CountriesService())..loadCountryDetail(cca2),
      child: Scaffold(
        appBar: AppBar(
          title: Text(countryName),
        ),
        body: BlocBuilder<CountryDetailCubit, CountryDetailState>(
          builder: (context, state) {
            if (state is CountryDetailLoading || state is CountryDetailInitial) {
              return const _DetailLoading();
            } else if (state is CountryDetailError) {
              return _DetailError(
                message: state.message,
                onRetry: () => context.read<CountryDetailCubit>().loadCountryDetail(cca2),
              );
            } else if (state is CountryDetailLoaded) {
              return _DetailContent(details: state.country, flagUrl: flagUrl);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DetailLoading extends StatelessWidget {
  const _DetailLoading();
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _DetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _DetailError({required this.message, required this.onRetry});
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

class _DetailContent extends StatelessWidget {
  final CountryDetails details;
  final String flagUrl;
  const _DetailContent({required this.details, required this.flagUrl});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'flag_${details.cca2}',
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(flagUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(details.name, style: textTheme.headlineSmall, maxLines: 2),
                const SizedBox(height: 8),
                _InfoRow(label: 'Population', value: _formatNumber(details.population)),
                _InfoRow(label: 'Area', value: '${_formatNumber(details.area.round())} km²'),
                _InfoRow(label: 'Region', value: details.region),
                _InfoRow(label: 'Subregion', value: details.subregion),
                _InfoRow(label: 'Capital', value: details.capital.isNotEmpty ? (details.capital.first.toString()) : '—'),
                const SizedBox(height: 16),
                Text('Timezones', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: details.timezones.map<Widget>((t) {
                    return Chip(label: Text(t.toString()));
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(num value) {
    return value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: TextStyle(color: color))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

