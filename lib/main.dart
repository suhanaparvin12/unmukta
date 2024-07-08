import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safewomen/child/bottom_page.dart';
import 'package:safewomen/db/share_pref.dart';
import 'package:safewomen/child/child_login_screen.dart';
import 'package:safewomen/parent/parent_home_screen.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:safewomen/utils/flutter_background_services.dart';
import 'package:shake/shake.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPrefference.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await initializeService();
  runApp(const MyApp());
}

Color brandColor = Color(0xfffc3b77);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    //////Shake feature/////
    ShakeDetector.autoStart(
      onPhoneShake: () {},
      minimumShakeCount: 3,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? dark) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && dark != null) {
        lightColorScheme = lightDynamic.harmonized()..copyWith();
        lightColorScheme = lightColorScheme.copyWith(secondary: brandColor);
        darkColorScheme = dark.harmonized();
      } else {
        lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor);
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: brandColor,
          brightness: Brightness.dark,
        );
      }

      return MaterialApp(
        title: 'UnMukta',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Theme.of(context).colorScheme.surface,
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        home: FutureBuilder(
          future: MySharedPrefference.getUserType(),
          builder: (context, snapshot) {
            if (snapshot.data == "child") {
              return BottomPage();
            }
            if (snapshot.data == "parent") {
              return const ParentHomeScreen();
            }
            if (snapshot.data == "") {
              return LoginScreen();
            }
            return progressIndicator(context);
          },
        ),
      );
    });
  }
}

/* class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  CheckData() {
    if (MySharedPrefference.getUserType() == 'parent') {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
} */
