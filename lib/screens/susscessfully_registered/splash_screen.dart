import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_library/screens/home_page/home_page.dart';
import 'package:my_library/screens/welcome_screen/welcome.dart';
import 'package:my_library/widgets/components.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool letsGo = false;

  @override
  void initState() {
    super.initState();
    final ap = Provider.of<MyAuthProvider>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 3000)).then((value) async {
      if (ap.isSignedIn == true) {
        await ap
            .getUserDataFromSP()
            .whenComplete(() => navigateScaleUntil(context, const HomePage()));
      } else {
        navigateSlideUntil(context, const WelcomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/orange_splash_screen.json'),
          ],
        ),
      ),
    );
  }
}
