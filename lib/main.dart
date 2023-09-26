import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'api_key.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'presentation/configurations/textstyles.dart';
import 'presentation/widgets/setup_bottomsheet_ui.dart';
import 'presentation/widgets/setup_dialog_ui.dart';
import 'presentation/widgets/setup_snackbar_ui.dart';
import 'presentation/configurations/colors.dart';

final getIt = GetIt.asNewInstance();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:75325963614:ios:76b87a9fefa1fde63063cf',
      apiKey: apiKey,
      projectId: 'flutter-firebase-plugins',
      messagingSenderId: '297855924061',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:75325963614:android:321e99f087c2cb613063cf',
      apiKey: apiKey,
      messagingSenderId: '297855924061',
      projectId: 'vielly-8b429',
      databaseURL: 'https://vielly-8b429.firebaseio.com',
    ),
  );

  await ThemeManager.initialise();
  setupLocator();
  setupDialogUi();
  setupSnackbarUi();
  setupBottomSheetUi();
  runApp(MyApp());
}








class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultThemeMode: ThemeMode.system,
      //themes: getThemes(),

      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: darkTextTheme,
        snackBarTheme: SnackBarThemeData(contentTextStyle: ThemeText_BodyText_1.apply(color: Colors.white),),
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'DIN Next Rounded LT W04',
      ),

      lightTheme: ThemeData(
        colorScheme: lightColorScheme,
        textTheme: lightTextTheme,
        snackBarTheme: SnackBarThemeData(contentTextStyle: ThemeText_Heading_6.apply(color: Colors.white),),
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'DIN Next Rounded LT W04',
      ),

      builder: (context, regularTheme, darkTheme, themeMode) => GetMaterialApp(
        title: 'Curve',
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode!,

        navigatorObservers: [StackedService.routeObserver],
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute:  StackedRouter().onGenerateRoute,
        initialRoute: Routes.splashScreenView,
        debugShowCheckedModeBanner: false,

        onGenerateTitle: (context) {
          return AppLocalizations.of(context)!.appTitle;
        },

        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          // 'en' is the language code. We could optionally provide a
          // a country code as the second param, e.g.
          // Locale('en', 'US'). If we do that, we may want to
          // provide an additional app_en_US.arb file for
          // region-specific translations.
          const Locale('en', ''),
          const Locale('fr', ''),
        ],
      ),
    );
  }
}


/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: ExtendedNavigator.builder(
        router: AppRouter(),
        initialRoute: Routes.startupView,
        navigatorKey: locator<NavigationService>().navigatorKey,
        builder: (_, navigator) =>
            Theme(
              data: ThemeData.light(),
              child: navigator,
            ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

 */