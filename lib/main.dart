import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nu_challenge/core/platform/scaffold_handler.dart';

import 'core/config/app_setup.dart';
import 'core/errors/error_widget.dart';
import 'core/navigation/app_navigator.dart';
import 'core/navigation/routes.dart';
import 'core/ui/theme/main_theme.dart';
import 'modules/customer/infra/customer_setup.dart';

void main() {
  runApp(NuChallenge());
}

class NuChallenge extends StatefulWidget {
  const NuChallenge({Key? key}) : super(key: key);

  @override
  _NuChallengeState createState() => _NuChallengeState();
}

class _NuChallengeState extends State<NuChallenge> {
  late Future initApp;

  @override
  void initState() {
    initApp = Future(() async {
      await AppSetup.init();
      CustomerSetup().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initApp,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.hasError) {
          return CustomErrorWidget(
            error: snapshot.error!,
            stackTrace: snapshot.stackTrace!,
          );
        }

        return MaterialApp(
          navigatorKey: GetIt.I<AppNavigator>().navigatorKey,
          scaffoldMessengerKey: GetIt.I<ScaffoldHandler>().scaffoldKey,
          theme: mainTheme,
          routes: routes,
          initialRoute: '/',
        );
      },
    );
  }
}
