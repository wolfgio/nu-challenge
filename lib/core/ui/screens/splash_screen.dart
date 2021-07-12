import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../navigation/app_navigator.dart';
import '../styles/colors.dart';

class SplashScreen extends StatefulWidget {
  final AppNavigator appNavigator;

  const SplashScreen({
    Key? key,
    required this.appNavigator,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 4), () {
      widget.appNavigator.pushAndReplace('/home');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset('assets/images/splash_screen_bg.png').image,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Text(
              'CITADEL MARKETPLACE',
              style: TextStyle(
                fontFamily: 'Schwifty',
                fontSize: 54,
                color: ColorsPallete.primary,
                shadows: [
                  Shadow(
                    blurRadius: 1.6,
                    color: ColorsPallete.accent,
                    offset: Offset(3, 0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}

// bg color -> #88fd5a
