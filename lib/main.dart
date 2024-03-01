import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_library/provider/auth_provider.dart';
import 'package:my_library/screens/susscessfully_registered/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MyAuthProvider()),
    ],
    child: ScreenUtilInit(
      designSize: const Size(411.4, 867.4),
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Library',
            theme: ThemeData(
                primarySwatch: Colors.orange,
                appBarTheme: const AppBarTheme()
                    .copyWith(backgroundColor: Colors.orange, elevation: 8)),
            home: const MyApp());
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
