import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resturant_delivery_boy/data/model/response/response_model.dart';
import 'package:resturant_delivery_boy/data/model/body/TrackBody.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/base/error_response.dart';
import 'package:resturant_delivery_boy/data/repository/tracker_repo.dart';

class TrackerProvider extends ChangeNotifier {
  final TrackerRepo trackerRepo;
  TrackerProvider({@required this.trackerRepo});

  List<TrackBody> _trackList = [];
  int _selectedTrackIndex = 0;
  bool _isBlockButton = false;
  bool _canDismiss = true;
  bool _startTrack = false;
  Timer _timer;

  List<TrackBody> get trackList => _trackList;
  int get selectedTrackIndex => _selectedTrackIndex;
  bool get isBlockButton => _isBlockButton;
  bool get canDismiss => _canDismiss;
  bool get startTrack => _startTrack;

  void startLocationService() async {
    _startTrack = true;
    addTrack();
    if(_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      addTrack();
    });
  }

  void stopLocationService() {
    _startTrack = false;
    if(_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    notifyListeners();
  }

  Future<ResponseModel> addTrack() async {
    ResponseModel _responseModel;
    if (_startTrack) {
      Geolocator.getCurrentPosition().then((location) async {
        String _location = 'demo';
        try {
          List<Placemark> _placeMark = await placemarkFromCoordinates(location.latitude, location.longitude);
          Placemark _address = _placeMark.first;
          _location = '${_address.name ?? ''}, ${_address.subAdministrativeArea ?? ''}, ${_address.isoCountryCode ?? ''}' ?? 'demo';
        }catch(e) {}
        ApiResponse apiResponse = await trackerRepo.addTrack(location.latitude, location.longitude, _location);
        if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
          _responseModel = ResponseModel(true, 'Successfully start track');
        } else {
          String errorMessage;
          if (apiResponse.error is String) {
            print(apiResponse.error.toString());
            errorMessage = apiResponse.error.toString();
          } else {
            ErrorResponse errorResponse = apiResponse.error;
            print(errorResponse.errors[0].message);
            errorMessage = errorResponse.errors[0].message;
          }
          _responseModel = ResponseModel(false, errorMessage);
        }
      });
    } else {
      _timer.cancel();
    }
    notifyListeners();

    return _responseModel;
  }

  Future<bool> setOrderID(int orderID) async {
    return await trackerRepo.setOrderID(orderID);
  }
}
