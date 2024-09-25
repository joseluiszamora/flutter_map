part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool isFollowingUser;
  final LatLng? lastKnownLocation;
  final List<LatLng> myLocationHistory;

  const LocationState(
      {this.isFollowingUser = false, this.lastKnownLocation, myLocationHistory})
      : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? isFollowingUser,
    LatLng? lastKnownLocation,
    List<LatLng>? myLocationHistory,
  }) =>
      LocationState(
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
        myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      );

  @override
  List<Object?> get props =>
      [isFollowingUser, lastKnownLocation, myLocationHistory];
}
