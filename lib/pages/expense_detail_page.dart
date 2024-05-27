import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpenseDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const ExpenseDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String dateText = data['date'] ?? '';
    String costText = data['cost'] ?? '';
    String personText = data['person'] ?? '';
    String locationText = data['location'] ?? '';
    String imgUrl = data['imgUrl'] ?? '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 51, 51),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.details_of_expense,
          style: const TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imgUrl.isNotEmpty)
                Center(
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '${AppLocalizations.of(context)!.amount}: $costText Ft',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '${AppLocalizations.of(context)!.location}: $locationText',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '${AppLocalizations.of(context)!.date}: $dateText',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '${AppLocalizations.of(context)!.spent_with}: $personText',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
