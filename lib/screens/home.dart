import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../model/modelCountry.dart';
import '../widgets/card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CardSwiperController controller = CardSwiperController();
  final TextEditingController searchController = TextEditingController();

  List<CountryModel> countries = [];
  List<CountryModel> filteredCountries = [];
  bool isSearching = false;
  CountryModel? foundCountry;
  bool showHighlight = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final String response = await rootBundle.loadString('assets/data/countries.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      countries = data.map((json) => CountryModel.fromJson(json)).toList();
      countries.shuffle();
      filteredCountries = List.from(countries);
    });
  }

  CountryModel _createEmptyCountry() {
    return CountryModel(
      name: '',
      capital: '',
      population: 0,
      area: 0,
      phoneCode: '',
      flag: '',
      region: '',
      language: '',
      countryCode: '',
    );
  }

  String normalize(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s]'), '') // supprime caractères spéciaux
        .replaceAll(RegExp(r'\s+'), '');   // supprime espaces multiples
  }

  void _onSearchChanged() {
    final query = normalize(searchController.text);

    if (query.isEmpty) {
      setState(() {
        filteredCountries = List.from(countries);
        isSearching = false;
        foundCountry = null;
        showHighlight = false;
      });
      return;
    }

    setState(() {
      isSearching = true;

      // Filtrage partiel
      final filtered = countries.where((country) {
        return normalize(country.name).contains(query);
      }).toList();

      filteredCountries = filtered.isEmpty ? [_createEmptyCountry()] : filtered;

      // Recherche exacte
      foundCountry = countries.firstWhere(
            (country) => normalize(country.name) == query,
        orElse: () => _createEmptyCountry(),
      );

      if (foundCountry?.name.isEmpty ?? true) {
        foundCountry = null;
      }
    });

    if (foundCountry != null) {
      _highlightFoundCountry();
    }
  }

  void _highlightFoundCountry() {
    setState(() {
      showHighlight = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showHighlight = false;
        });
      }
    });
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    return true;
  }

  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un pays...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  if (filteredCountries.isNotEmpty)
                    CardSwiper(
                      controller: controller,
                      cardsCount: filteredCountries.length,
                      onSwipe: _onSwipe,
                      onUndo: _onUndo,
                      numberOfCardsDisplayed: math.min(3, filteredCountries.length),
                      backCardOffset: const Offset(40, 40),
                      padding: const EdgeInsets.all(24.0),
                      cardBuilder: (
                          context,
                          index,
                          horizontalThresholdPercentage,
                          verticalThresholdPercentage,
                          ) {
                        if (index < 0 || index >= filteredCountries.length) {
                          return const SizedBox();
                        }

                        final country = filteredCountries[index];
                        if (country.name.isEmpty) {
                          return const SizedBox();
                        }

                        final isFoundCountry = foundCountry != null &&
                            country.name == foundCountry!.name;

                        return CountryCard(
                          country: country,
                          isHighlighted: showHighlight && isFoundCountry,
                        );
                      },
                    ),
                  if (filteredCountries.isEmpty && isSearching)
                    const Center(child: Text('Aucun résultat trouvé')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.top),
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.bottom),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
