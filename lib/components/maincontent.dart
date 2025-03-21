import 'package:VoxAi/extension/extension.dart';
import 'package:VoxAi/model/chatmessage.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

import '../providers/providers.dart';

Component cards(BuildContext context) {
  final invisibleContent = context.watch(invisibleContentProvider);

  return div(
      classes:
          '  grid  grid-cols-1 $invisibleContent sm:grid-cols-2 lg:grid-cols-3 gap-4 w-full  max-w-xl mx-auto px-4',
      [
        for (var card in [
          (
            title: 'Smart Chat Assistant',
            subtitle: 'Natural Language AI',
            icon: 'assets/images/chatbot.svg'
          ),
          (
            title: 'Voice Recognition',
            subtitle: 'Accurate Speech Processing',
            icon: 'assets/images/audio.svg'
          ),
          (
            title: 'Predictive Analysis',
            subtitle: 'Data-Driven Insights',
            icon: 'assets/images/chart.svg'
          ),
        ])
          div(
              classes:
                  'bg-white p-4 rounded-3xl shadow-md flex flex-col items-center hover:shadow-lg transition-shadow',
              [
                div(
                    classes:
                        "card rounded-full shadow-lg transition-shadow justify-center  mx-auto w-12 h-12 bg-black",
                    [
                      img(
                          src: card.icon,
                          alt: card.title,
                          classes: 'h-8 w-8   mx-auto  sm:h-8 sm:w-8 '),
                    ]),
                h2(
                    classes: 'text-base sm:text-lg poppins-bold text-center',
                    [text(card.title)]),
                p(
                    classes:
                        'text-sm sm:text-base text-gray-600 poppins-thin text-center',
                    [text(card.subtitle)]),
              ]),
      ]);
}

Component chatui(BuildContext context) {
  final invisibleChat = context.watch(invisibleChatProvider);
  final messages = context.watch(messagesProvider);
  final qwenResponse = context.watch(responseProvider);
  final geminiResponse = context.watch(responseGeminiProvider);
  final selectedModel = context.watch(selectedAIModelProvider);

  // Check if there's a response based on the selected model
  final hasResponse = selectedModel == "qwen" 
      ? qwenResponse != null 
      : geminiResponse != null;

  return div(
      classes:
          " $invisibleChat mx-auto  w-full h-1/2 flex flex-col space-y-4 overflow-y-auto p-2",
      [
        if (messages.isNotEmpty)  // Show messages if there are any, regardless of response
          for (var message in messages)
            div(
                classes:
                    "chat ${message.isSent ? "chat-start" : "chat-end"} w-full max-w-full sm:max-w-[80%] md:max-w-[70%]",
                [
                  div(
                      attributes: {
                        '::after': "",
                      },
                      classes:
                          "${message.isSent ? "typewriter chat-bubble" : "chat-bubble"} break-words px-3 py-2 text-sm sm:text-base",
                      [
                        h6(id: "tw", classes: "whitespace-pre-wrap", [
                          RawText(Extension().formatResponse(message.content)!),
                        ]),
                      ]),
                ]),
      ]);
}

Component inputask(
  BuildContext context,
) {
  final inputValue = context.watch(inputValueProvider);
  final isLoading = context.watch(isLoadingProvider);
  final error = context.watch(errorProvider);

  return div(classes: 'relative w-3/4 max-w-2xl mx-auto', [
    input(value: inputValue, classes: '''
              w-full p-4  rounded-lg poppins-thin shadow-md 
              pr-24 text-sm focus:outline-none focus:ring-2 
              focus:ring-black border border-gray-200
              ${isLoading ? 'opacity-50' : ''}
            ''', attributes: {
      'placeholder': 'Type your message here...',
    }, onChange: (value) {
      context.read(inputValueProvider.notifier).state = value;
    }, type: InputType.text, []),
    button(
        onClick: isLoading
            ? null
            : () async {
                try {
                  {
                    if (!Extension().isSpeaking()) Extension().dispose();

                    final currentInput = context.read(inputValueProvider);
                    if (currentInput.trim().isEmpty) return;

                    // Update UI state
                    context.read(invisibleContentProvider.notifier).state =
                        'invisible';
                    context.read(invisibleChatProvider.notifier).state = '';
                    print(
                        "state invisble chat : ${context.read(invisibleChatProvider.notifier).state}");
                    context.read(heightCardProvider.notifier).state =
                        'h-screen';
                    context.read(isLoadingProvider.notifier).state = true;
                    context.read(errorProvider.notifier).state = null;

                    // Add user message
                    final newMessage = Chatmessage(
                      content: currentInput,
                      isSent: false,
                      timestamp: DateTime.now(),
                    );

                    context
                        .read(messagesProvider.notifier)
                        .update((state) => [...state, newMessage]);

                    // Get selected AI model
                    final selectedModel = context.read(selectedAIModelProvider);

                    // Generate response
                    final apiService = context.read(apiServiceProvider);
                    if (selectedModel == "qwen") {
                      final response =
                          await apiService.generateResponse(currentInput);
                      context.read(responseProvider.notifier).state = response;

                      // Process response
                      if (response.choices.isNotEmpty) {
                        Extension().tts(response.choices[0].message.content);

                        final aiMessage = Chatmessage(
                          content: response.choices[0].message.content,
                          isSent: true,
                          timestamp: DateTime.now(),
                        );

                        context
                            .read(messagesProvider.notifier)
                            .update((state) => [...state, aiMessage]);
                      }
                    }

                    if (selectedModel == "gemini") {
                      final response =
                          await apiService.generateGeminiResponse(currentInput);
                      context.read(responseGeminiProvider.notifier).state =
                          response;

                      // Process response
                      if (response.candidates.isNotEmpty) {
                        Extension()
                            .tts(response.candidates[0].content.parts[0].text!);

                        final aiMessage = Chatmessage(
                          content:
                              response.candidates[0].content.parts[0].text!,
                          isSent: true,
                          timestamp: DateTime.now(),
                        );
                        context
                            .read(messagesProvider.notifier)
                            .update((state) => [...state, aiMessage]);
                      }
                    }

                    // Update response state
                  }
                  print("update loading");

                  // Clear input and loading state
                  context.read(inputValueProvider.notifier).state = "";
                  context.read(isLoadingProvider.notifier).state = false;
                } catch (e) {
                  context.read(errorProvider.notifier).state =
                      'Something went wrong. Please try again.';
                  context.read(isLoadingProvider.notifier).state = false;
                }
              },
        classes: '''
              absolute right-2 top-1 bg-black poppins-bold text-white px-3 py-3 rounded-full
              text-base hover:bg-gray-800 transition-all duration-200
              ${isLoading ? 'opacity-50 cursor-not-allowed' : 'hover:scale-105 shadow-lg'}
            ''',
        disabled: isLoading,
        [
          isLoading
              ? div(classes: 'flex items-center gap-2', [
                  text('Loading'),
                  div(
                      classes:
                          'animate-spin h-4 w-4 border-2 border-white rounded-full border-t-transparent',
                      [])
                ])
              : text('Send')
        ]),
  ]);
}

Component textwelcome() {
  return div(
      classes: 'text-center   w-full max-w-6xl mx-auto px-4 md:px-8 lg:px-16',
      [
        img(
            src: 'assets/images/applogo.png',
            alt: 'Avatar',
            classes:
                'w-20 h-20 sm:w-24 sm:h-24 md:w-32 md:h-32 rounded-full mb-4 mx-auto'),
        h1(
            classes:
                'text-xl sm:text-2xl animate__animated  animate__bounceInLeft animate__bounce md:text-3xl lg:text-4xl poppins-bold mb-2',
            [text('Hi, Everyone!')]),
        p(
            classes:
                'text-sm sm:text-base md:text-lg poppins-regular mb-4 md:mb-6',
            [text('Can I help you with anything?')]),
        p(
            classes:
                'text-xs sm:text-sm md:text-base text-gray-700 mb-6 md:mb-8 poppins-thin max-w-2xl mx-auto',
            [
              text(
                  'Ready to assist you with anything you need, from answering questions to providing recommendations. Let\'s get started!')
            ]),
      ]);
}

Component toggleAi(BuildContext context) {
  final selectedModel = context.watch(selectedAIModelProvider);

  return div(classes: 'flex items-center justify-center space-x-2 mb-4', [
    // Gemini option
    div(classes: 'flex items-center', [
      input(type: InputType.radio, attributes: {
        'id': 'gemini',
        'name': 'ai-model',
        'value': 'gemini',
        "checked": selectedModel == 'gemini' ? "checked" : ""
      }, onChange: (_) {
        context.read(selectedAIModelProvider.notifier).state = 'gemini';

        // Ensure chat UI visibility is consistent when switching models
        final messages = context.read(messagesProvider);
        if (messages.isNotEmpty) {
          context.read(invisibleChatProvider.notifier).state = '';
          context.read(invisibleContentProvider.notifier).state = 'invisible';
        }
      }, classes: 'mr-1 cursor-pointer', []),
      label(
          attributes: {'for': 'gemini'},
          classes:
              'text-sm cursor-pointer poppins-regular ${selectedModel == "gemini" ? "text-black font-semibold" : "text-gray-600"}',
          [text('Gemini')]),
    ]),

    // Qwen option
    div(classes: 'flex items-center', [
      input(type: InputType.radio, attributes: {
        'id': 'qwen',
        'name': 'ai-model',
        'value': 'qwen',
        'checked': selectedModel == 'qwen' ? 'checked' : '',
      }, onChange: (_) {
        context.read(selectedAIModelProvider.notifier).state = 'qwen';

        // Ensure chat UI visibility is consistent when switching models
        final messages = context.read(messagesProvider);
        if (messages.isNotEmpty) {
          context.read(invisibleChatProvider.notifier).state = '';
          context.read(invisibleContentProvider.notifier).state = 'invisible';
        }
      }, classes: 'mr-1 cursor-pointer', []),
      label(
          attributes: {'for': 'qwen'},
          classes:
              'text-sm cursor-pointer poppins-regular ${selectedModel == "qwen" ? "text-black font-semibold" : "text-gray-600"}',
          [text('Qwen')]),
    ]),

    // Current model indicator
    div(classes: 'ml-2 text-xs bg-gray-200 px-2 py-1 rounded-full', [
      text(
          'Using ${selectedModel.substring(0, 1).toUpperCase()}${selectedModel.substring(1)}')
    ]),
  ]);
}

class MainContent extends StatelessComponent {
  const MainContent({super.key});

  Component body(BuildContext context) {
    return div(
        classes:
            'flex flex-col items-center justify-center min-h-screen p-4 bg-gradient-to-r from-blue-100 via-sky-100 to-indigo-200',
        [
          textwelcome(),
          toggleAi(context), // Added the AI toggle component
          chatui(context),
          cards(context),
          div(
              classes: 'w-full max-w-2xl mx-auto py-3 px-4 flex justify-center',
              [
                inputask(
                  context,
                ),
              ]),
        ]);
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    // uses context to access providers

    yield Builder(builder: (context) sync* {
      yield body(context);
    });
  }
}
