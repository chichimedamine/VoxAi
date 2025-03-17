import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    var activePath = RouteState.of(context).location;

    yield header([
      div(
          classes:
              'bg-gradient-to-r from-blue-100 via-sky-100 to-indigo-200 shadow-md p-4 flex justify-between items-center',
          [
            div(
              classes: 'flex items-center',
              [
                img(
                    src: 'assets/images/applogo.png',
                    alt: 'VoxAi Logo',
                    classes: 'h-8 w-8 mr-2'),
                span(classes: 'text-xl  poppins-bold', [
                  text('VoxAi'),
                ]),
              ],
            ),
            div(classes: "github_img", [
              a( href: "https://github.com/chichimedamine/VoxAi",  [
                div(classes: "w-8 rounded-xl", [
                  img(
                      alt: "github",
                      src:
                          "assets/images/github.png",
                      classes: "h-8 w-8 rounded-xl")
                ]),
              ])
            ])
          ]),
    ]);
  }
}
