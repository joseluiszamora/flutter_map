import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/blocs/blocs.dart';
import 'package:flutter_maps/views/views.dart';
import 'package:flutter_maps/widgets/btn_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    // locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    super.dispose();
    locationBloc.stopFollowingUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.lastKnownLocation == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Stack(
              children: [
                MapView(initialLocation: state.lastKnownLocation!),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [BtnCurrentLocation()],
      ),
    );
  }
}
