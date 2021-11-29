import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/localization_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final int index;
  OrderWidget({this.orderModel, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(.5), spreadRadius: 1, blurRadius: 1, offset: Offset(0, 1))],
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    getTranslated('order_id', context),
                    style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                  Text(
                    ' # ${orderModel.id.toString()}',
                    style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ],
              ),
              Stack(
                clipBehavior: Clip.none, children: [
                  Container(),
                  Provider.of<LocalizationProvider>(context).isLtr
                      ? Positioned(
                          right: -10,
                          top: -23,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL),
                                    bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_SMALL))),
                            child: Text(
                              getTranslated('${orderModel.orderStatus}', context),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(color: Theme.of(context).primaryColorDark, fontSize: Dimensions.FONT_SIZE_SMALL),
                            ),
                          ),
                        )
                      : Positioned(
                          left: -10,
                          top: -28,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL),
                                    bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_SMALL))),
                            child: Text(
                              getTranslated('${orderModel.orderStatus}', context),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(color: Theme.of(context).primaryColorDark, fontSize: Dimensions.FONT_SIZE_SMALL),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Image.asset(Images.location, color: Theme.of(context).textTheme.bodyText1.color, width: 15, height: 20),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                orderModel.deliveryAddress != null ? orderModel.deliveryAddress.address : 'Address not found',
                style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
              )),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                btnTxt: getTranslated('view_details', context),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModel: orderModel, index: index)));
                },
                isShowBorder: true,
              )),
              SizedBox(width: 20),
              Expanded(
                  child: CustomButton(
                      btnTxt: getTranslated('direction', context),
                      onTap: () {
                        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
                          MapUtils.openMap(
                              double.parse(orderModel.deliveryAddress.latitude) ?? 23.8103,
                              double.parse(orderModel.deliveryAddress.longitude) ?? 90.4125,
                              position.latitude ?? 23.8103,
                              position.longitude ?? 90.4125);
                        });
                      })),
            ],
          ),
        ],
      ),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double destinationLatitude, double destinationLongitude, double userLatitude, double userLongitude) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude'
        '&destination=$destinationLatitude,$destinationLongitude&mode=d';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
