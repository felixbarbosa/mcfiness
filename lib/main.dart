import 'package:flutter/material.dart';
import 'package:mcfitness/model/user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:mcfitness/pages/avaliacaoFisica/avaliacaoFisica_nova_avaliacao.dart';
import 'package:mcfitness/pages/home/home_page.dart';
import 'package:mcfitness/pages/login/login.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  runApp(
    Provider(
      create: (_) => User(versao: 'V3.20220824.1930'/*packageInfo.version*/),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Vendor',
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
          iconTheme: const IconThemeData(color: Colors.blue)),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      themeMode: ThemeMode.light,
      home: const Login(),
      ),
    ),
  );
}
