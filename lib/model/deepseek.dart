class Choice {
  final dynamic logprobs;
  final String finishReason;
  final String nativeFinishReason;
  final int index;
  final Message message;

  Choice({
    this.logprobs,
    required this.finishReason,
    required this.nativeFinishReason,
    required this.index,
    required this.message,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
      nativeFinishReason: json['native_finish_reason'],
      index: json['index'],
      message: Message.fromJson(json['message']),
    );
  }
}

class DeepSeekResponse {
  final String id;
  final String provider;
  final String model;
  final String object;
  final int created;
  final List<Choice> choices;
  final Usage usage;

  DeepSeekResponse({
    required this.id,
    required this.provider,
    required this.model,
    required this.object,
    required this.created,
    required this.choices,
    required this.usage,
  });

  factory DeepSeekResponse.fromJson(Map<String, dynamic> json) {
    return DeepSeekResponse(
      id: json['id'],
      provider: json['provider'],
      model: json['model'],
      object: json['object'],
      created: json['created'],
      choices:
          (json['choices'] as List).map((e) => Choice.fromJson(e)).toList(),
      usage: Usage.fromJson(json['usage']),
    );
  }
}

class Message {
  final String role;
  final String content;
  final dynamic refusal;
  final String? reasoning;

  Message({
    required this.role,
    required this.content,
    this.refusal,
    this.reasoning,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
      refusal: json['refusal'],
      reasoning: json['reasoning'],
    );
  }
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}
