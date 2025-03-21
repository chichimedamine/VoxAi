import 'package:markdown/markdown.dart';
import 'package:text_to_speech/text_to_speech.dart';

class Extension {
  // Create a single instance of TextToSpeech to reuse
  final TextToSpeech _tts = TextToSpeech();
  bool is_speaking = false;

  /// Alternative implementation that keeps only letters and numbers
  String cleanStringAlphaNumeric(String text) {
    return text
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Stops any ongoing speech and releases resources
  dispose() {
    _tts.stop();
    is_speaking = false;

    // Some TTS engines might need additional cleanup
    // If the package provides a dispose or release method, call it here
  }

  String? formatResponse(String? response) {
    if (response == null) return null;

    return markdownToHtml(response, extensionSet: ExtensionSet.gitHubWeb);
  }

  bool isSpeaking() {
    if (is_speaking) return true;
    return false;
  }

  dynamic tts(String text) {
    String cleantext = cleanStringAlphaNumeric(text);
    _tts.setLanguage('en');
    _tts.setRate(0.5);
    _tts.setPitch(0.8);
    is_speaking = true;
    return _tts.speak(cleantext);
  }
}
