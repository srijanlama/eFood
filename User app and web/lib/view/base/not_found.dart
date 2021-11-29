import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar():null,
      body: Center(
          child: TweenAnimationBuilder(
            curve: Curves.bounceOut,
        duration: Duration(seconds: 2),
        tween: Tween<double>(begin: 12.0,end: 30.0),
        builder: (BuildContext context, dynamic value, Widget child){
              return Text('Page Not Found',style: TextStyle(fontWeight: FontWeight.bold,fontSize: value));
        },

        ),
      ),
    );
  }
}
