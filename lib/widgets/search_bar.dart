import 'package:deborah/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = '';
            controller.clear();
          },
        ),
      ),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }
}
