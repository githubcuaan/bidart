import 'package:bidart/screens/people/widgets/filter_modal.dart';
import 'package:flutter/material.dart';

class PeopleTopBar extends StatelessWidget {
  const PeopleTopBar({super.key});

  void _openFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.tune, size: 26),
              onPressed: () => _openFilter(context),
            ),
          ],
        ),
      ),
    );
  }
}
