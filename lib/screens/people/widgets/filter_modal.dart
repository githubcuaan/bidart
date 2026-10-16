import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  double maxDistance = 10.0;

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
            activeColor: Colors.deepPurple,
            onChanged: (val) {
              setState(() => maxDistance = val);
            },
          ),
          const SizedBox(height: 12),
          const Text('Ưu tiên thể loại:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(label: const Text('Bida Lỗ (Pool)'), selected: true, onSelected: (_) {}),
              FilterChip(label: const Text('Carom 3C'), selected: false, onSelected: (_) {}),
              FilterChip(label: const Text('Libre'), selected: false, onSelected: (_) {}),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Áp dụng bộ lọc'),
            ),
          ),
        ],
      ),
    );
  }
}
