import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nu_challenge/core/ui/styles/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
