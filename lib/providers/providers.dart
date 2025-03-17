// Provider for API service
import 'package:VoxAi/model/chatmessage.dart';
import 'package:VoxAi/model/deepseek.dart';
import 'package:VoxAi/services/apiservice.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final errorProvider = StateProvider<String?>((ref) => null);
final heightCardProvider = StateProvider<String>((ref) => 'h-1/2');
final inputValueProvider = StateProvider<String>((ref) => '');
final invisibleChatProvider = StateProvider<String>((ref) => "invisible");
final invisibleContentProvider = StateProvider<String>((ref) => "");
final isLoadingProvider = StateProvider<bool>((ref) => false);
// Define providers for the state
final messagesProvider = StateProvider<List<Chatmessage>>((ref) => []);

final responseProvider = StateProvider<DeepSeekResponse?>((ref) => null);
