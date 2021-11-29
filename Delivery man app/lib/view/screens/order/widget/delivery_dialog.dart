import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/helper/price_converter.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/auth_provider.dart';
import 'package:resturant_delivery_boy/provider/order_provider.dart';
import 'package:resturant_delivery_boy/provider/tracker_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_details_screen.dart';
import 'package:resturant_delivery_boy/view/screens/order/order_place_screen.dart';
import 'package:provider/provider.dart';

class DeliveryDialog extends StatelessWidget {
  final Function onTap;
  final OrderModel orderModel;
  final int index;
  final double totalPrice;

  DeliveryDialog({@required this.onTap, this.totalPrice, this.orderModel, @required this.index});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.2)),
        child: Stack(
          clipBehavior: Clip.none, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.asset(Images.money),
                SizedBox(height: 20),
                Center(
                    child: Text(
                  getTranslated('do_you_collect_money', context),
                  style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).focusColor),
                )),
                SizedBox(height: 20),
                Center(
                    child: Text(
                  PriceConverter.convertPrice(context, totalPrice),
                  style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).focusColor,fontSize: 30),
                )),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      btnTxt: getTranslated('no', context),
                      isShowBorder: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModel: orderModel, index: index)));
                      },
                    )),
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(
                        child: Consumer<OrderProvider>(
                      builder: (context, order, child) {
                        return !order.isLoading ? CustomButton(
                          btnTxt: getTranslated('yes', context),
                          onTap: () {
                            Provider.of<TrackerProvider>(context, listen: false).stopLocationService();
                            Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(
                                token: Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                orderId: orderModel.id,
                                index: index,
                                status: 'delivered').then((value) {
                              if (value.isSuccess) {
                                order.updatePaymentStatus(
                                    token: Provider.of<AuthProvider>(context, listen: false).getUserToken(), orderId: orderModel.id, status: 'paid');
                                Provider.of<OrderProvider>(context, listen: false).getAllOrders(context);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(builder: (_) => OrderPlaceScreen(orderID: orderModel.id.toString())));
                              }
                            });
                          },
                        ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                      },
                    )),
                  ],
                ),
              ],
            ),
            Positioned(
              right: -20,
              top: -20,
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.clear, size: Dimensions.PADDING_SIZE_LARGE),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModel: orderModel, index: index)));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
