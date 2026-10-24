import 'package:bidart/features/matchmaking/provider/matchmaking_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterModal extends ConsumerStatefulWidget {
  const FilterModal({super.key});

  @override
  ConsumerState<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends ConsumerState<FilterModal> {
  late double maxDistance;

  @override
  void initState() {
    super.initState();
    maxDistance = ref.read(matchmakingFilterProvider).maxDistanceKm;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bộ lọc tìm đối thủ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Khoảng cách tối đa: ${maxDistance.toInt()} km',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: maxDistance,
            min: 1,
            max: 50,
            divisions: 49,
            onChanged: (val) {
              setState(() => maxDistance = val);
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ref.read(matchmakingFilterProvider.notifier).updateDistance(maxDistance);
                Navigator.pop(context);
              },
              child: const Text('Áp dụng bộ lọc'),
            ),
          ),
        ],
      ),
    );
  }
}
