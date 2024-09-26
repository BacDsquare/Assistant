class MessageModel {
  final String id;
  final String object;
  final int createdAt;
  final String? assistantId;
  final String threadId;
  final String? runId;
  final String role;
  final List<Content> content;
  final List<dynamic> attachments;
  final Map<String, dynamic> metadata;

  MessageModel({
    required this.id,
    required this.object,
    required this.createdAt,
    this.assistantId,
    required this.threadId,
    this.runId,
    required this.role,
    required this.content,
    required this.attachments,
    required this.metadata,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List;
    List<Content> contentItems = contentList.map((i) => Content.fromJson(i)).toList();

    return MessageModel(
      id: json['id'],
      object: json['object'],
      createdAt: json['created_at'],
      assistantId: json['assistant_id'],
      threadId: json['thread_id'],
      runId: json['run_id'],
      role: json['role'],
      content: contentItems,
      attachments: json['attachments'],
      metadata: json['metadata'],
    );
  }
}

class Content {
  final String type;
  final TextContent text;

  Content({required this.type, required this.text});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      type: json['type'],
      text: TextContent.fromJson(json['text']),
    );
  }
}

class TextContent {
  final String value;
  final List<dynamic> annotations;

  TextContent({required this.value, required this.annotations});

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(
      value: json['value'],
      annotations: json['annotations'],
    );
  }
}
