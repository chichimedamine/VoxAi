// The entrypoint for the **client** environment.
//
// This file is compiled to javascript and executed in the browser.

// Imports the [App] component.
import 'package:VoxAi/app.dart';
import 'package:VoxAi/extension/extension.dart';

import 'package:jaspr/browser.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

void main() async {
  // Attaches the [App] component to the <body> of the page.
  Extension().dispose();
  runApp(ProviderScope(
    child: App(),
  ));
}
