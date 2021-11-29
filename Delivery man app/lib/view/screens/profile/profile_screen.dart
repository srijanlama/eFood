import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/auth_provider.dart';
import 'package:resturant_delivery_boy/provider/profile_provider.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/base/status_widget.dart';
import 'package:resturant_delivery_boy/view/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/view/screens/html/html_viewer_screen.dart';
import 'package:resturant_delivery_boy/view/screens/profile/widget/profile_button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        getTranslated('my_profile', context),
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColorDark),
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorResources.COLOR_WHITE, width: 3)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_user, width: 80, height: 80, fit: BoxFit.fill,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.deliveryManImageUrl}/${profileProvider.userInfoModel.image}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, width: 80, height: 80, fit: BoxFit.fill),
                            )),
                      ),
                      SizedBox(height: 20),
                      Text(
                        profileProvider.userInfoModel.fName != null
                            ? '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}'
                            : "",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColorDark),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('theme_style', context),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          StatusWidget()
                        ],
                      ),
                      SizedBox(height: 20),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel.fName),
                      SizedBox(height: 15),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel.lName),
                      SizedBox(height: 15),
                      _userInfoWidget(context: context, text: profileProvider.userInfoModel.phone),
                      SizedBox(height: 20),
                      ProfileButton(icon: Icons.privacy_tip, title: getTranslated('privacy_policy', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HtmlViewerScreen(isPrivacyPolicy: true)));
                      }),
                      SizedBox(height: 10),
                      ProfileButton(icon: Icons.list, title: getTranslated('terms_and_condition', context), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HtmlViewerScreen(isPrivacyPolicy: false)));
                      }),
                      SizedBox(height: 10),
                      ProfileButton(icon: Icons.logout, title: getTranslated('logout', context), onTap: () {
                        Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                        });
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _userInfoWidget({String text, BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).cardColor,
          border: Border.all(color: ColorResources.BORDER_COLOR)),
      child: Text(
        text ?? '',
        style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).focusColor),
      ),
    );
  }
}
