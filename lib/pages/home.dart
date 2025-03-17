import 'package:VoxAi/components/maincontent.dart';
import 'package:jaspr/jaspr.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section([
      MainContent(),
    ]);
  }
}
