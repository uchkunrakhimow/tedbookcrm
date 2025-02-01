import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tedbook/firebase_options.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/pages/home/home_page.dart';
import 'package:tedbook/pages/login/bloc/login_bloc.dart';
import 'package:tedbook/pages/login/login_page.dart';
import 'package:tedbook/pages/sample/bloc/sample_bloc.dart';
import 'package:tedbook/persistance/service_locator.dart';
import 'package:tedbook/persistance/user_data.dart';
import 'package:tedbook/utils/color_utils.dart';

GetIt getIt = GetIt.instance;
bool _hasToken = false;

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  final UserData _userData = getInstance();
  _hasToken = (await _userData.accessToken())?.isNotEmpty == true;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginBloc()),
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(create: (context) => SampleBloc()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: AppColor.scaffoldBackColor,
        brightness: Brightness.light,
      ),
      title: 'Material App',
      home: _hasToken ? HomePage() : LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
