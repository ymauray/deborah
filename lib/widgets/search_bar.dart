import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    ValueChanged<String>? onChanged,
    VoidCallback? onRefresh,
    String? initialValue,
    Key? key,
  })  : _onChanged = onChanged,
        _onRefresh = onRefresh,
        _initialValue = initialValue,
        super(key: key);

  final ValueChanged<String>? _onChanged;
  final VoidCallback? _onRefresh;
  final String? _initialValue;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget._initialValue ?? '';
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
                    widget._onChanged?.call('');
                    controller.clear();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              onChanged: widget._onChanged,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          OutlinedButton(
            onPressed: widget._onRefresh,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                'Refresh',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
