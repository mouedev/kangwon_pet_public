import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final String title;
  final LatLng latLng;
  final CameraPosition cameraPosition;

  GoogleMapWidget(this.title, latitude, longitude, {super.key})
      : latLng = LatLng(latitude, longitude),
        cameraPosition =
            CameraPosition(target: LatLng(latitude, longitude), zoom: 17);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    Marker marker = Marker(
        markerId: MarkerId(widget.title),
        position: widget.latLng,
        infoWindow: InfoWindow(title: widget.title));

    _markers = {marker};
  }

  @override
  Widget build(BuildContext context) {
    double minSize = math.min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    final mapSize = Size(minSize, minSize);

    return Scaffold(
      backgroundColor: const Color(0xFF343945),
      body: Center(
          child: SizedBox(
              width: mapSize.width,
              height: mapSize.height,
              child: _googleMapSection(widget.cameraPosition))),
    );
  }

  Widget _googleMapSection(CameraPosition cameraPosition) => GoogleMap(
        initialCameraPosition: cameraPosition,
        markers: _markers,
      );
}
