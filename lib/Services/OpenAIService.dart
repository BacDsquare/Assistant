import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/AssistantModel.dart';
import '../Models/MessageModel.dart';

class OpenAIService {
  final String apiKey;
  String assistantId = '';
  String? currentThreadID;

  OpenAIService(this.apiKey);

  Future<AssistantResponse> createAssistant() async {
    final url = Uri.parse('https://api.openai.com/v1/assistants');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Beta': 'assistants=v2',
      },
      body: jsonEncode(
        AssistantDefinition(
          model: 'gpt-3.5-turbo-0125',
          name: 'bac',
          instructions: 'Calculate software costs.',
        ).toJson(),
      ),
    );

    if (response.statusCode == 200) {
      return AssistantResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create assistant: ${response.body}');
    }
  }

  Future<ThreadResponse> createThread() async {
    final url = Uri.parse('https://api.openai.com/v1/threads');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Beta': 'assistants=v2',
      },
    );

    if (response.statusCode == 200) {
      return ThreadResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create thread: ${response.body}');
    }
  }

  Future<void> addMessageToThread(String role, String content) async {
    final url = Uri.parse('https://api.openai.com/v1/threads/$currentThreadID/messages');
    final message = Message(role: role, content: content);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Beta': 'assistants=v2',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add message: ${response.body}');
    }
  }

  Future<void> runAssistantOnThread() async {
    final url = Uri.parse('https://api.openai.com/v1/threads/$currentThreadID/runs');
    final requestData = {
      'assistant_id': assistantId,
      'stream': true,
    };

    final request = http.Request('POST', url)
      ..headers.addAll({
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Beta': 'assistants=v2',
      })
      ..body = jsonEncode(requestData);

    final response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        print('Assistant Response: $value');

      });
    } else {
      print('Failed to run assistant: ${response.reasonPhrase}');
    }
  }

  Future<List<MessageModel>> getMessagesFromThread() async {
    final url = Uri.parse('https://api.openai.com/v1/threads/$currentThreadID/messages');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Beta': 'assistants=v2',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      var messagesResponse = MessagesResponse.fromJson(data);
      return messagesResponse.data;
    } else {
      throw Exception('Failed to get messages: ${response.body}');
    }
  }
}
