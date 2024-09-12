import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc()
      : super(
            const GpsState(isGpsEnabled: true, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>(
      (event, emit) => emit(
        state.copyWith(
          isGpsEnabled: event.isGpsEnabled,
          isGpsPermissionGranted: event.isGpsPermissionGranted,
        ),
      ),
    );

    _init();
  }

  Future<void> _init() async {
    // concatena los Futures, par que se lancen al mismo tiempo
    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted(),
    ]);

    add(
      GpsAndPermissionEvent(
        isGpsEnabled: gpsInitStatus[0],
        isGpsPermissionGranted: gpsInitStatus[1],
      ),
    );
  }

  Future<bool> _isPermissionGranted() async {
    final status = await Permission.location.isGranted;
    return status;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((status) {
      final isEnable = (status.index == 1) ? true : false;
      add(
        GpsAndPermissionEvent(
          isGpsEnabled: isEnable,
          isGpsPermissionGranted: state.isGpsPermissionGranted,
        ),
      );
    });

    return isEnable;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isGpsPermissionGranted: true,
        );
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.provisional:
        GpsAndPermissionEvent(
          isGpsEnabled: state.isGpsEnabled,
          isGpsPermissionGranted: false,
        );
        openAppSettings();
    }
  }

  @override
  Future<void> close() {
    // cancelar la suscripción
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
