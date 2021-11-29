import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/main_slider.dart';
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/set_menu_view.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

  Future<void> _loadData(BuildContext context, bool reload) async {
    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context, true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    await Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(
      context, reload,Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
    await Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    _loadData(context, false);

    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: ColorResources.getBackgroundColor(context),
      drawer: ResponsiveHelper.isTab(context) ? Drawer(child: OptionsView(onTap: null)) : SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(context, true);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(controller: _scrollController, slivers: [

              // AppBar
              ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(child: SizedBox()) : SliverAppBar(
                  floating: true,
                  elevation: 0,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).cardColor,
                  pinned: ResponsiveHelper.isTab(context) ? true : false,
                  leading: ResponsiveHelper.isTab(context) ? IconButton(
                    onPressed: () => drawerGlobalKey.currentState.openDrawer(),
                    icon: Icon(Icons.menu,color: Colors.black),
                  ): null,
                  title: Consumer<SplashProvider>(builder:(context, splash, child) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ResponsiveHelper.isWeb() ? FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_rectangle, height: 40, width: 40,
                        image: splash.baseUrls != null ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}' : '',
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle, height: 40, width: 40),
                      ) : Image.asset(Images.logo, width: 40, height: 40),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ResponsiveHelper.isWeb() ? splash.configModel.restaurantName : AppConstants.APP_NAME,
                          style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                      icon: Icon(Icons.notifications, color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    ResponsiveHelper.isTab(context) ? IconButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.shopping_cart, color: Theme.of(context).textTheme.bodyText1.color),
                          Positioned(
                            top: -10, right: -10,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                              child: Center(
                                child: Text(
                                  Provider.of<CartProvider>(context).cartList.length.toString(),
                                  style: rubikMedium.copyWith(color: Colors.white, fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) : SizedBox(),
                  ],
                ),

              // Search Button
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(child: Center(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.getSearchRoute()),
                    child: Container(
                      height: 60, width: 1170,
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(color: ColorResources.getSearchBg(context), borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL), child: Icon(Icons.search, size: 25)),
                          Expanded(child: Text(getTranslated('search_items_here', context), style: rubikRegular.copyWith(fontSize: 12))),
                        ]),
                      ),
                    ),
                  ),
                )),
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      ResponsiveHelper.isDesktop(context) ? Padding(
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                        child: MainSlider(),
                      ):  SizedBox(),

                      Consumer<CategoryProvider>(
                        builder: (context, category, child) {
                          return category.categoryList == null ? CategoryView() : category.categoryList.length == 0 ? SizedBox() : CategoryView();
                        },
                      ),

                      Consumer<SetMenuProvider>(
                        builder: (context, setMenu, child) {
                          return setMenu.setMenuList == null ? SetMenuView() : setMenu.setMenuList.length == 0 ? SizedBox() : SetMenuView();
                        },
                      ),

                      ResponsiveHelper.isDesktop(context) ? SizedBox() : Consumer<BannerProvider>(
                        builder: (context, banner, child) {
                          return banner.bannerList == null ? BannerView() : banner.bannerList.length == 0 ? SizedBox() : BannerView();
                        },
                      ) ,

                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TitleWidget(title: getTranslated('popular_item', context)),
                      ),
                      ProductView(productType: ProductType.POPULAR_PRODUCT, scrollController: _scrollController),

                    ]),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),

    );
  }
}
//ResponsiveHelper

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 60 || oldDelegate.minExtent != 60 || child != oldDelegate.child;
  }
}
