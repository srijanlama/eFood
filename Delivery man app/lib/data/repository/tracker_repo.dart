import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/body/TrackBody.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  TrackerRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> addTrack(double lat, double long, String location) async {
    try {
      TrackBody _trackBody = TrackBody(
        orderId: sharedPreferences.getInt(AppConstants.ORDER_ID).toString(),
        token: sharedPreferences.getString(AppConstants.TOKEN),
        latitude: lat, longitude: long, location: location,
      );
      Response response = await dioClient.post(AppConstants.RECORD_LOCATION_URI, data: _trackBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> setOrderID(int orderID) async {
    return await sharedPreferences.setInt(AppConstants.ORDER_ID, orderID);
  }

}