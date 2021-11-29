import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';
import 'package:flutter_restaurant/view/screens/order/widget/order_shimmer.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({@required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel> orderList;
          if(order.runningOrderList != null) {
            orderList = isRunning ? order.runningOrderList.reversed.toList() : order.historyOrderList.reversed.toList();
          }

          return orderList != null ? orderList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: ListView.builder(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      itemCount: orderList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(
                              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                              spreadRadius: 1, blurRadius: 5,
                            )],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(children: [

                            Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  Images.placeholder_image,
                                  height: 70, width: 80, fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Text(orderList[index].id.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Expanded(child: orderList[index].orderType == 'take_away' ? Text(
                                      '(${getTranslated('take_away', context)})',
                                      style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                    ) : SizedBox()),
                                  ]),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    '${orderList[index].detailsCount} ${getTranslated( orderList[index].detailsCount > 1 ? 'items' : 'item', context)}',
                                    style: rubikRegular.copyWith(color: ColorResources.COLOR_GREY),
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Row(children: [
                                    Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 15),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Text(
                                      '${orderList[index].orderStatus[0].toUpperCase()}${orderList[index].orderStatus.substring(1).replaceAll('_', ' ')}',
                                      style: rubikRegular.copyWith(color: Theme.of(context).primaryColor),
                                    ),
                                  ]),
                                ]),
                              ),
                            ]),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            SizedBox(
                              height: 50,
                              child: Row(children: [
                                Expanded(child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(width: 2, color: ColorResources.DISABLE_COLOR),
                                    ),
                                    minimumSize: Size(1, 50),
                                    padding: EdgeInsets.all(0),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.getOrderDetailsRoute(orderList[index].id),
                                      arguments: OrderDetailsScreen(orderModel: orderList[index], orderId: orderList[index].id),
                                    );
                                  },
                                  child: Text(getTranslated('details', context), style: Theme.of(context).textTheme.headline3.copyWith(
                                    color: ColorResources.DISABLE_COLOR,
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                  )),
                                )),
                                SizedBox(width: 20),
                                Expanded(child: CustomButton(
                                  btnTxt: getTranslated(isRunning ? 'track_order' : 'reorder', context),
                                  onTap: () async {
                                    if(isRunning) {
                                      Navigator.pushNamed(context, Routes.getOrderTrackingRoute(orderList[index].id));
                                    }else {
                                      List<OrderDetailsModel> orderDetails = await order.getOrderDetails(orderList[index].id.toString(), context);
                                      List<CartModel> _cartList = [];
                                      orderDetails.forEach((orderDetail) {
                                        List<AddOn> _addOnList = [];
                                        for(int i=0; i<orderDetail.addOnIds.length; i++) {
                                          _addOnList.add(AddOn(id: orderDetail.addOnIds[i], quantity: orderDetail.addOnQtys[i]));
                                        }
                                        _cartList.add(CartModel(
                                            orderDetail.price, PriceConverter.convertWithDiscount(context, orderDetail.price, orderDetail.discountOnProduct, 'amount'),
                                            orderDetail.variation, orderDetail.discountOnProduct, orderDetail.quantity,
                                            orderDetail.taxAmount, _addOnList, orderDetail.productDetails
                                        ));
                                      });
                                      Navigator.pushNamed(
                                        context,
                                        Routes.getCheckoutRoute(
                                          orderList[index].orderAmount, 'reorder', orderList[index].orderType,
                                          orderList[index].couponDiscountTitle ?? '',
                                        ),
                                        arguments: CheckoutScreen(
                                          cartList: _cartList,
                                          fromCart: false,
                                          amount: orderList[index].orderAmount,
                                          orderType: orderList[index].orderType,
                                          couponCode: orderList[index].couponDiscountTitle ?? '',
                                        ),
                                      );
                                    }
                                  },
                                )),
                              ]),
                            ),

                          ]),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen(isOrder: true) : OrderShimmer();
        },
      ),
    );
  }
}
