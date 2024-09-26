
import 'package:assistants/Models/MessageModel.dart';

class AssistantDefinition {
  final String model;
  final String name;
  final String instructions;

  AssistantDefinition({
    required this.model,
    required this.name,
    required this.instructions,
  });

  Map<String, dynamic> toJson() => {
    'model': model,
    'name': name,
    'instructions': instructions,
  };
}

class AssistantResponse {
  final String id;

  AssistantResponse({required this.id});

  factory AssistantResponse.fromJson(Map<String, dynamic> json) {
    return AssistantResponse(
      id: json['id'],
    );
  }
}

class ThreadResponse {
  final String id;

  ThreadResponse({required this.id});

  factory ThreadResponse.fromJson(Map<String, dynamic> json) {
    return ThreadResponse(
      id: json['id'],
    );
  }
}

class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(role: json['id'], content: json['content']);
  }
}

class MessagesResponse {
  final List<MessageModel> data;
  final String firstId;
  final String lastId;
  final bool hasMore;

  MessagesResponse({
    required this.data,
    required this.firstId,
    required this.lastId,
    required this.hasMore,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<MessageModel> messagesList = dataList.map((i) => MessageModel.fromJson(i)).toList();

    return MessagesResponse(
      data: messagesList,
      firstId: json['first_id'],
      lastId: json['last_id'],
      hasMore: json['has_more'],
    );
  }
}