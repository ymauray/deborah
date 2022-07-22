import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    this.onChanged,
    this.initialValue,
    Key? key,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;
  final String? initialValue;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 0.0, top: 16.0),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: TextFormField(
              //initialValue: initialValue,
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () {
                    widget.onChanged?.call('');
                    controller.clear();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
