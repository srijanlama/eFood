import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/search/widget/filter_widget.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchString;
  SearchResultScreen({@required this.searchString});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    int atamp = 0;
    if (atamp == 0) {
      _searchController.text = widget.searchString;
      atamp = 1;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)?PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)):null,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      width: 1170,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: getTranslated('search_items_here', context),
                              isShowBorder: true,
                              isShowSuffixIcon: true,
                              suffixIconUrl: Images.filter,
                              controller: _searchController,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Images.search,
                              inputAction: TextInputAction.search,
                              isIcon: true,

                              onSuffixTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      List<double> _prices = [];
                                      searchProvider.filterProductList.forEach((product) => _prices.add(product.price));
                                      _prices.sort();
                                      double _maxValue = _prices.length > 0 ? _prices[_prices.length-1] : 1000;
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child: Container(
                                            width: 550,
                                            child: FilterWidget(maxValue: _maxValue)),
                                      );
                                    });

                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  searchProvider.searchProductList != null ? Center(
                    child: SizedBox(
                      width: 1170,
                      child: Text(
                        '${searchProvider.searchProductList.length} ${getTranslated('product_found', context)}',
                        style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                      ),
                    ),
                  ) : SizedBox.shrink(),
                  SizedBox(height: 13),
                  Expanded(
                    child: searchProvider.searchProductList != null ? searchProvider.searchProductList.length > 0 ? Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Center(
                          child: SizedBox(
                            width: 1170,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: searchProvider.searchProductList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 3,
                                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 1),
                              itemBuilder: (context, index) => ProductWidget(product: searchProvider.searchProductList[index]),
                            ),
                          ),
                        ),
                      ),
                    ) : NoDataScreen() : GridView.builder(
                      itemCount: 10,//searchProvider.searchProductList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 3,
                        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 1,
                      ),
                      itemBuilder: (context, index) => ProductShimmer(isEnabled: searchProvider.searchProductList == null),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
