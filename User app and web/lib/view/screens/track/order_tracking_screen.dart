import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/track/widget/custom_stepper.dart';
import 'package:flutter_restaurant/view/screens/track/widget/delivery_man_widget.dart';
import 'package:flutter_restaurant/view/screens/track/widget/tracking_map_widget.dart';
import 'package:provider/provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderID;
  OrderTrackingScreen({@required this.orderID,});

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(orderID, context);
    Provider.of<OrderProvider>(context, listen: false).trackOrder(orderID, null, context, true);

    final List<String> _statusList = ['pending', 'confirmed', 'processing' ,'out_for_delivery', 'delivered', 'returned', 'failed', 'canceled'];

    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('order_tracking', context)),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          String _status;
          if(order.trackModel != null) {
            _status = order.trackModel.orderStatus;
          }

          if(_status != null && _status == _statusList[5] || _status == _statusList[6] || _status == _statusList[7]) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_status),
                SizedBox(height: 50),
                CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                }),
              ],
            );
          } else if(order.responseModel != null && !order.responseModel.isSuccess) {
            return Center(child: Text(order.responseModel.message));
          }

          return _status != null ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(orderID, context);
              await Provider.of<OrderProvider>(context, listen: false).trackOrder(orderID, null, context, true);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        order.trackModel.deliveryMan != null ? DeliveryManWidget(deliveryMan: order.trackModel.deliveryMan) : SizedBox(),
                        order.trackModel.deliveryMan != null ? SizedBox(height: 30) : SizedBox(),

                        CustomStepper(
                          title: getTranslated('order_placed', context),
                          isActive: true,
                          haveTopBar: false,
                        ),
                        CustomStepper(
                          title: getTranslated('order_accepted', context),
                          isActive: _status != _statusList[0],
                        ),
                        CustomStepper(
                          title: getTranslated('preparing_food', context),
                          isActive: _status != _statusList[0] && _status != _statusList[1],
                        ),
                        order.trackModel.orderType != 'take_away' ? CustomStepper(
                          title: getTranslated('food_in_the_way', context),
                          isActive: _status != _statusList[0] && _status != _statusList[1] && _status != _statusList[2],
                        ) : SizedBox(),
                        CustomStepper(
                          title: getTranslated('delivered_the_food', context),
                          isActive: _status == _statusList[4], height: _status == _statusList[3] ? 240 : 30,
                          child: _status == _statusList[3] ? TrackingMapWidget(
                            deliveryManModel: order.deliveryManModel,
                            orderID: orderID,
                            addressModel: Provider.of<LocationProvider>(context).addressList!= null ? Provider.of<LocationProvider>(context).addressList.where((address) => address.id == order.trackModel.deliveryAddressId).first : null,
                          ) : null,
                        ),
                        SizedBox(height: 50),

                        CustomButton(btnTxt: getTranslated('back_home', context), onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                        }),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
