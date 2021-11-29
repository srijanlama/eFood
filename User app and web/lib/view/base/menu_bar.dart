import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/mars_menu_bar.dart';
import 'package:provider/provider.dart';

class MenuBar extends StatelessWidget {

  List<MenuItem> getMenus(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return [
      MenuItem(
        title: getTranslated('home', context),
        icon: Icons.home_filled,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
      ),
      MenuItem(
        title: getTranslated('set_menu', context),
        icon: Icons.fastfood_outlined,
        onTap: () => Navigator.pushNamed(context, Routes.getSetMenuRoute()),
      ),
      MenuItem(
        title: getTranslated('necessary_links', context),
        icon: Icons.settings,
        children: [
          MenuItem(
            title: getTranslated('privacy_policy', context),
            onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
          ),
          MenuItem(
            title: getTranslated('terms_and_condition', context),
            onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
          ),
          MenuItem(
            title: getTranslated('about_us', context),
            onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
          ),

        ],
      ),
      MenuItem(
        title: getTranslated('favourite', context),
        icon: Icons.favorite_border,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('favourite')),
      ),

      MenuItem(
        title: getTranslated('menu', context),
        icon: Icons.menu,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('menu')),
      ),

      _isLoggedIn ?  MenuItem(
        title: getTranslated('profile', context),
        icon: Icons.person,
        onTap: () =>  Navigator.pushNamed(context, Routes.getProfileRoute()),
      ):  MenuItem(
        title: getTranslated('login', context),
        icon: Icons.lock,
        onTap: () => Navigator.pushNamed(context, Routes.getLoginRoute()),
      ),
      MenuItem(
        title: '',
        icon: Icons.shopping_cart,
        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      //color: Colors.white,
    width: 800,
      child: PlutoMenuBar(
        backgroundColor: Theme.of(context).cardColor,
        gradient: false,
        goBackButtonText: 'Back',
        textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        moreIconColor: Theme.of(context).textTheme.bodyText1.color,
        menuIconColor: Theme.of(context).textTheme.bodyText1.color,
        menus: getMenus(context),

      ),
    );
  }
}