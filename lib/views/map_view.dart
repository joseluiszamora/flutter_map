import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/map/map_bloc.dart';
import '../themes/uber.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;

  const MapView({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition =
        CameraPosition(target: initialLocation, zoom: 15);

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: GoogleMap(
        style: jsonEncode(uberMapTheme),
        initialCameraPosition: initialCameraPosition,
        compassEnabled: false,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,

        onMapCreated: (controller) =>
            mapBloc.add(OnMapInitialzedEvent(controller)),

        // TODO: Markers
        // TODO: polylines
        // TODO: Cuando se mueve el mapa
      ),
    );
  }
}
