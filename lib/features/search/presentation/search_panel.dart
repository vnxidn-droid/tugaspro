import 'package:flutter/material.dart';

class SearchPanel extends StatelessWidget {
  const SearchPanel({
    super.key,
    required this.queryController,
    required this.extensionController,
    required this.recursive,
    required this.onRecursiveChanged,
    required this.onSearch,
  });

  final TextEditingController queryController;
  final TextEditingController extensionController;
  final bool recursive;
  final ValueChanged<bool> onRecursiveChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: queryController,
              decoration: const InputDecoration(
                labelText: 'Smart search',
                hintText: 'nama, sebagian nama, path, mime, atau isi teks',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => onSearch(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: extensionController,
                    decoration: const InputDecoration(
                      labelText: 'Extension filter',
                      hintText: 'p, pdf, peg, apk, image',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                const SizedBox(width: 10),
                FilterChip(
                  selected: recursive,
                  label: const Text('Recursive'),
                  onSelected: onRecursiveChanged,
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: onSearch,
                  icon: const Icon(Icons.manage_search_rounded),
                  label: const Text('Search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
