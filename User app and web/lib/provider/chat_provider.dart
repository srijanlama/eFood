import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/chat_model.dart';
import 'package:flutter_restaurant/data/repository/chat_repo.dart';
import 'package:image_picker/image_picker.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({@required this.chatRepo});

  List<ChatModel> _chatList;
  List<bool> _showDate;
  List<DateTime> _dateList;
  PickedFile _imageFile;
  bool _isSendButtonActive = false;

  List<ChatModel> get chatList => _chatList;
  List<bool> get showDate => _showDate;
  PickedFile get imageFile => _imageFile;
  bool get isSendButtonActive => _isSendButtonActive;

  void getChatList(BuildContext context) async {
    _imageFile = null;
    ApiResponse apiResponse = await chatRepo.getChatList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _chatList = [];
      _showDate = [];
      _dateList = [];
      List<dynamic> _chats = apiResponse.response.data[0].reversed.toList();
      _chats.forEach((chat) {
        ChatModel chatModel = ChatModel.fromJson(chat);
        DateTime _originalDateTime = DateConverter.isoStringToLocalDate(chatModel.createdAt);
        DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
        bool _addDate = false;
        if(!_dateList.contains(_convertedDate)) {
          _addDate = true;
          _dateList.add(_convertedDate);
        }
        _chatList.add(chatModel);
        _showDate.add(_addDate);
      });
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> sendMessage(String message, String token, String userID, BuildContext context) async {
    PickedFile _pickedFile = _imageFile;
    _imageFile = null;
    notifyListeners();
    http.StreamedResponse response = await chatRepo.sendMessage(message, _pickedFile, token);
    if (response.statusCode == 200) {
      if(_pickedFile != null) {
        getChatList(context);
      }else {
        ChatModel _chatModel = ChatModel(
          userId: int.parse(userID), image: null, message: message, reply: null,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        DateTime _originalDateTime = DateConverter.isoStringToLocalDate(_chatModel.createdAt);
        DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
        bool _addDate = false;
        if(!_dateList.contains(_convertedDate)) {
          _addDate = true;
          _dateList.add(_convertedDate);
        }
        _chatList.add(_chatModel);
        _showDate.add(_addDate);
      }
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    _imageFile = null;
    _isSendButtonActive = false;
    notifyListeners();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImage(PickedFile image) {
    _imageFile = image;
    notifyListeners();
  }

}