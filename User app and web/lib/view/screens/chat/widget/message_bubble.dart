import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/chat_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final ChatModel chat;
  final bool addDate;
  MessageBubble({@required this.chat, @required this.addDate});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat.reply == null;
    String dateTime = DateConverter.isoStringToLocalTimeOnly(chat.createdAt);
    String _date = DateConverter.isoStringToLocalDateOnly(chat.createdAt) == DateConverter.estimatedDate(DateTime.now()) ? 'Today'
        : DateConverter.isoStringToLocalDateOnly(chat.createdAt) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
        ? 'Yesterday' : DateConverter.isoStringToLocalDateOnly(chat.createdAt);

    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        addDate ? Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Align(alignment: Alignment.center, child: Text(_date, style: rubikMedium, textAlign: TextAlign.center)),
        ) : SizedBox(),
        Padding(
          padding: isMe ?  EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 50, 5),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                            bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: isMe ? ColorResources.getHintColor(context) : ColorResources.getSearchBg(context),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                              child: Text(isMe ? chat.message : chat.reply, style: rubikRegular.copyWith(color: isMe ? Theme.of(context).cardColor
                                  : Theme.of(context).textTheme.bodyText1.color)),
                            ),

                            chat.image != null ? ClipRRect(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(isMe ? 10 : 0), bottomRight: Radius.circular(isMe ? 0 : 10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder_image, width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth,
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.chatImageUrl}/${chat.image}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
                              ),
                            ) : SizedBox(),
                          ],
                        ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1),
              Text(dateTime, style: rubikRegular.copyWith(fontSize: 8, color: ColorResources.COLOR_GREY_BUNKER)),
            ],
          ),
        ),
      ],
    );
  }
}
