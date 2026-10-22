import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Map tab content. The surrounding [Scaffold] and app bar are provided by
/// the shell, so this widget must not add its own.
class MapView extends StatelessWidget {
  const MapView({super.key});

  // Tọa độ mẫu (Hà Nội)
  static const LatLng _initialPosition = LatLng(21.028511, 105.804817);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: _initialPosition,
        initialZoom: 14.0,
      ),
      children: [
        // Lớp hiển thị Tile bản đồ OSM
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.de/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.bidart',
        ),
        // Lớp hiển thị Marker (điểm đánh dấu)
        const MarkerLayer(
          markers: [
            Marker(
              point: _initialPosition,
              width: 40,
              height: 40,
              child: Icon(Icons.location_on, size: 40, color: Colors.red),
            ),
          ],
        ),
        // OSM tile usage policy requires visible attribution
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );
  }
}
