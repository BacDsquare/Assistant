import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../Models/MessageModel.dart';
import '../Services/OpenAIService.dart';

class AssistantViewModel extends ChangeNotifier {
  final OpenAIService _openAIService;
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;
  final FlutterTts _flutterTts = FlutterTts();
  final String LANG = "vi-VN";
  AssistantViewModel(this._openAIService);
  Future<void> createAssistant() async {
    try {
      await _openAIService.createAssistant();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> createThread() async {
    try {
      var threadResponse = await _openAIService.createThread();
      _openAIService.currentThreadID = threadResponse.id;
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addMessage(String role, String content) async {
    try {
      await _openAIService.addMessageToThread(role, content);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> runAssistant() async {
    try {
      await _openAIService.runAssistantOnThread();
      await fetchMessages();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchMessages() async {
    try {
      _messages = await _openAIService.getMessagesFromThread();
      for(MessageModel mesage in _messages){
  if(mesage.role=="assistant"){
  print(mesage.content[0].text.value);
  await speak(mesage.content[0].text.value);
  }
}
notifyListeners();
} catch (e) {
// Handle error
}
}

  Future<void> speak(String message) async {
    try {
      List<dynamic> languages = await _flutterTts.getLanguages;
      print(languages);
      bool isLangageAvailable = await _flutterTts.isLanguageAvailable(LANG);
      if(isLangageAvailable)
        {
          await _flutterTts.setLanguage(LANG);
          await _flutterTts.setPitch(1.0);
          await _flutterTts.speak(message);
        }
      print(isLangageAvailable);
    } catch (e) {
      print("Error setting language: $e");
    }
  }
}
