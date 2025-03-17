import 'dart:convert';

class Content {
  final List<Part> parts;
  final String? role;

  Content({
    required this.parts,
    this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      parts:
          (json['parts'] as List).map((part) => Part.fromJson(part)).toList(),
      role: json['role'],
    );
  }
}

class GeminiCandidate {
  final Content content;
  final String? finishReason;
  final int? index;
  final List<SafetyRating>? safetyRatings;

  GeminiCandidate({
    required this.content,
    this.finishReason,
    this.index,
    this.safetyRatings,
  });

  factory GeminiCandidate.fromJson(Map<String, dynamic> json) {
    return GeminiCandidate(
      content: Content.fromJson(json['content']),
      finishReason: json['finishReason'],
      index: json['index'],
      safetyRatings: json['safetyRatings'] != null
          ? (json['safetyRatings'] as List)
              .map((rating) => SafetyRating.fromJson(rating))
              .toList()
          : null,
    );
  }
}

class GeminiResponse {
  final List<GeminiCandidate> candidates;
  final PromptFeedback? promptFeedback;

  GeminiResponse({
    required this.candidates,
    this.promptFeedback,
  });

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(
      candidates: (json['candidates'] as List)
          .map((candidate) => GeminiCandidate.fromJson(candidate))
          .toList(),
      promptFeedback: json['promptFeedback'] != null
          ? PromptFeedback.fromJson(json['promptFeedback'])
          : null,
    );
  }
}

class InlineData {
  final String mimeType;
  final String data;

  InlineData({
    required this.mimeType,
    required this.data,
  });

  factory InlineData.fromJson(Map<String, dynamic> json) {
    return InlineData(
      mimeType: json['mimeType'],
      data: json['data'],
    );
  }

  // Helper method to get image bytes from base64 data
  List<int> get imageBytes => base64Decode(data);
}

class Part {
  final String? text;
  final InlineData? inlineData;

  Part({
    this.text,
    this.inlineData,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      text: json['text'],
      inlineData: json['inlineData'] != null
          ? InlineData.fromJson(json['inlineData'])
          : null,
    );
  }
}

class PromptFeedback {
  final List<SafetyRating>? safetyRatings;

  PromptFeedback({
    this.safetyRatings,
  });

  factory PromptFeedback.fromJson(Map<String, dynamic> json) {
    return PromptFeedback(
      safetyRatings: json['safetyRatings'] != null
          ? (json['safetyRatings'] as List)
              .map((rating) => SafetyRating.fromJson(rating))
              .toList()
          : null,
    );
  }
}

class SafetyRating {
  final String category;
  final String probability;

  SafetyRating({
    required this.category,
    required this.probability,
  });

  factory SafetyRating.fromJson(Map<String, dynamic> json) {
    return SafetyRating(
      category: json['category'],
      probability: json['probability'],
    );
  }
}
