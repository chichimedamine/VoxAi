// The entrypoint for the **client** environment.
//
// This file is compiled to javascript and executed in the browser.

// Imports the [App] component.
import 'package:VoxAi/app.dart';
import 'package:VoxAi/extension/extension.dart';
// Client-specific jaspr import.
import 'package:jaspr/browser.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

void main() {
  // Attaches the [App] component to the <body> of the page.
  Extension().dispose();
  runApp(ProviderScope(
    child: App(),
  ));
  // ApiService().getResponse("hello");
}
