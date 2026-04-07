import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'flutter_flow/flutter_flow_util.dart';

// ✅ NUEVO IMPORT
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ CARGAR .env (ANTES DE TODO)
  await dotenv.load(fileName: ".env");

  // ✅ INICIALIZACIÓN ROBUSTA PARA ANDROID
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase inicializado correctamente");
  } catch (e) {
    print("❌ Error inicializando Firebase: $e");
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  static String getRoute(BuildContext context) => of(context).getRoute();

  static List<String> getRouteStack(BuildContext context) =>
      of(context).getRouteStack();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  bool _initialized = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _appStateNotifier = AppStateNotifier.instance;
      _router = createRouter(_appStateNotifier);

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      print("✅ Firebase inicializado");

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          _appStateNotifier.stopShowingSplashImage();
          _router.go('/login');
        }
      });

      if (mounted) {
        safeSetState(() {
          _initialized = true;
        });
      }

    } catch (e) {
      print("❌ Error en inicialización: $e");
      if (mounted) {
        safeSetState(() {
          _initialized = true;
          _initError = e.toString();
          _appStateNotifier.stopShowingSplashImage();
          _router.go('/login');
        });
      }
    }
  }

  Future<void> _checkFirestoreConnection() async {
    try {
      await FirebaseFirestore.instance
          .collection('productos')
          .limit(1)
          .get()
          .timeout(Duration(seconds: 10));

      print("✅ Conexión Firestore exitosa");
    } catch (e) {
      print("⚠️ Check Firestore opcional falló: $e");
    }
  }

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() {
    return _router.routerDelegate.currentConfiguration.matches
        .whereType<RouteMatch>()
        .map((e) => getRoute(e))
        .toList();
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Image.asset(
              'assets/images/Splash_Screen.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    if (_initError != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 20),
                Text('Error de inicialización'),
                SizedBox(height: 10),
                Text(_initError!, textAlign: TextAlign.center),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _initializeApp(),
                  child: Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PriceQR',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}