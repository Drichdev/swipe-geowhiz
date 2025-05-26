import 'package:flutter/material.dart';
import '../model/modelCountry.dart';

class CountryCard extends StatefulWidget {
  final CountryModel country;
  final bool isHighlighted;

  const CountryCard({
    super.key,
    required this.country,
    this.isHighlighted = false,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {


  @override
  Widget build(BuildContext context) {
    final colors = _getCountryColors(widget.country.region);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: widget.isHighlighted ? EdgeInsets.all(10) : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: widget.isHighlighted ? EdgeInsets.all(10) : EdgeInsets.zero,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: widget.isHighlighted
                    ? Colors.transparent
                    : Colors.transparent),
            gradient: widget.isHighlighted
                ? LinearGradient(
                    colors: [
                      Color(0xfffc466b),
                      Color(0xff3f5efb),
                      Color(0xff7e3ffb)
                    ],
                    stops: [0.25, 0.75, 0.87],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.transparent, Colors.transparent],
                    stops: [0.25, 0.75],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: colors,
                        ),
                      ),
                      child: widget.country.flag.isNotEmpty
                          ? Image.network(
                              widget.country.flag,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            )
                          : const SizedBox(height: 250),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(child: _buildCountryDetails()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.country.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          children: [
            _infoChip(widget.country.region),
            _infoChip(widget.country.countryCode),
            _infoChip(widget.country.phoneCode),
          ],
        ),
        const SizedBox(height: 3),
        _infoRow('Capitale:', widget.country.capital),
        _divider(),
        _infoRow('Population:', '${widget.country.population}'),
        _divider(),
        _infoRow('Superficie:', '${widget.country.area} km²'),
        _divider(),
        _infoRow('Langue:', widget.country.language),
      ],
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _divider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );
  }

  List<Color> _getCountryColors(String region) {
    switch (region.toLowerCase()) {
      case 'africa':
        return const [Color(0xFF2F80ED), Color(0xFF56CCF2)];
      case 'europe':
        return const [Color(0xFF736EFE), Color(0xFF62E4EC)];
      case 'asia':
        return const [Color(0xFFFF3868), Color(0xFFFFB49A)];
      case 'americas':
        return const [Color(0xFF0BA4E0), Color(0xFFA9E4BD)];
      case 'oceania':
        return const [Color(0xFFF2994A), Color(0xFFF2C94C)];
      default:
        return const [Color(0xFF2F80ED), Color(0xFF56CCF2)];
    }
  }
}