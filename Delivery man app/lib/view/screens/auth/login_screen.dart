import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/helper/email_checker.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/provider/auth_provider.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/view/base/custom_button.dart';
import 'package:resturant_delivery_boy/view/base/custom_snackbar.dart';
import 'package:resturant_delivery_boy/view/base/custom_text_field.dart';
import 'package:resturant_delivery_boy/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail() ?? null;
    _passwordController.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword() ?? null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Form(
            key: _formKeyLogin,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                //SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Image.asset(
                    Images.logo,
                    height: MediaQuery.of(context).size.height / 4.5,
                    fit: BoxFit.scaleDown,
                    matchTextDirection: true,
                  ),
                ),
                //SizedBox(height: 20),
                Center(
                    child: Text(
                  getTranslated('login', context),
                  style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 24, color: Theme.of(context).hintColor),
                )),
                SizedBox(height: 35),
                Text(
                  getTranslated('email_address', context),
                  style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).highlightColor),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: getTranslated('demo_gmail', context),
                  isShowBorder: true,
                  focusNode: _emailFocus,
                  nextFocus: _passwordFocus,
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Text(
                  getTranslated('password', context),
                  style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).highlightColor),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: getTranslated('password_hint', context),
                  isShowBorder: true,
                  isPassword: true,
                  isShowSuffixIcon: true,
                  focusNode: _passwordFocus,
                  controller: _passwordController,
                  inputAction: TextInputAction.done,
                ),
                SizedBox(height: 22),

                // for remember me section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => InkWell(
                              onTap: () {
                                authProvider.toggleRememberMe();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                        color: authProvider.isActiveRememberMe ? Theme.of(context).primaryColor : ColorResources.COLOR_WHITE,
                                        border:
                                            Border.all(color: authProvider.isActiveRememberMe ? Colors.transparent : Theme.of(context).highlightColor),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: authProvider.isActiveRememberMe
                                        ? Icon(Icons.done, color: ColorResources.COLOR_WHITE, size: 17)
                                        : SizedBox.shrink(),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Text(
                                    getTranslated('remember_me', context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).highlightColor),
                                  )
                                ],
                              ),
                            )),
                  ],
                ),

                SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authProvider.loginErrorMessage.length > 0
                        ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                        : SizedBox.shrink(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authProvider.loginErrorMessage ?? "",
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    )
                  ],
                ),

                // for login button
                SizedBox(height: 10),
                !authProvider.isLoading
                    ? CustomButton(
                        btnTxt: getTranslated('login', context),
                        onTap: () async {
                          String _email = _emailController.text.trim();
                          String _password = _passwordController.text.trim();
                          if (_email.isEmpty) {
                            showCustomSnackBar(getTranslated('enter_email_address', context), context);
                          }else if (EmailChecker.isNotValid(_email)) {
                            showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                          }else if (_password.isEmpty) {
                            showCustomSnackBar(getTranslated('enter_password', context), context);
                          }else if (_password.length < 6) {
                            showCustomSnackBar(getTranslated('password_should_be', context), context);
                          }else {
                            authProvider.login(emailAddress: _email, password: _password).then((status) async {
                              if (status.isSuccess) {
                                if (authProvider.isActiveRememberMe) {
                                  authProvider.saveUserNumberAndPassword(_email, _password);
                                } else {
                                  authProvider.clearUserEmailAndPassword();
                                }
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen()));
                              }
                            });
                          }
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(ColorResources.COLOR_PRIMARY),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
