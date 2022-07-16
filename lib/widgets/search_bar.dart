import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    this.onChanged,
    Key? key,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 0.0, top: 16.0),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
