import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/notification_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)): CustomAppBar(context: context, title: getTranslated('notification', context)),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          List<DateTime> _dateTimeList = [];
          return notificationProvider.notificationList != null ? notificationProvider.notificationList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: ListView.builder(
                        itemCount: notificationProvider.notificationList.length,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DateTime _originalDateTime = DateConverter.isoStringToLocalDate(notificationProvider.notificationList[index].createdAt);
                          DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
                          bool _addTitle = false;
                          if(!_dateTimeList.contains(_convertedDate)) {
                            _addTitle = true;
                            _dateTimeList.add(_convertedDate);
                          }
                          return InkWell(
                            onTap: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return NotificationDialog(notificationModel: notificationProvider.notificationList[index]);
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _addTitle ? Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 2),
                                  child: Text(DateConverter.isoStringToLocalDateOnly(notificationProvider.notificationList[index].createdAt)),
                                ) : SizedBox(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                DateConverter.isoStringToLocalTimeOnly(notificationProvider.notificationList[index].createdAt),
                                                style: Theme.of(context).textTheme.headline2,
                                              ),
                                              Container(
                                                  width: 35,
                                                  height: 18,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL), color: ColorResources.getSearchBg(context)),
                                                  child: Text(
                                                    DateConverter.isoStringToLocalAMPM(notificationProvider.notificationList[index].createdAt),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2
                                                        .copyWith(fontSize: 11, color: ColorResources.getGrayColor(context).withOpacity(.8)),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(width: 24.0),
                                          Text(
                                            notificationProvider.notificationList[index].title,
                                            style: Theme.of(context).textTheme.headline2.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_LARGE,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Container(height: 1, color: ColorResources.COLOR_GREY.withOpacity(.2))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
          )
              : NoDataScreen()
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        }
      ),
    );
  }
}
