import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcfitness/model/user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mcfitness/pages/login/login.dart';
import 'package:mcfitness/pages/teste/firebase_options.dart';
import 'package:mcfitness/pages/widgets/error_page.dart';
import 'package:mcfitness/pages/widgets/loading_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
 
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  runApp(
    Provider(
      create: (_) => User(versao: 'V1.20220929.1655'/*packageInfo.version*/),
      child: App(),
    )
  );
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _inicializacao = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MC Fitness',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromARGB(255, 170, 170, 170),
        iconTheme: const IconThemeData(
          color: Colors.blue
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        future: _inicializacao,
        builder: (context, app) {
          if (app.connectionState == ConnectionState.done) {
            return Login(
            );
          }

          if (app.hasError) return const ErrorPage();

          return const LoadingPage();
        },
      ),
    );
  }
}
