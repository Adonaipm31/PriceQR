import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;
  bool _loggedIn = false;
  String? _userType;

  bool get loggedIn => _loggedIn;
  String? get userType => _userType;

  // ✅ MÉTODOS PARA MANEJAR ESTADO DE AUTH
  void setLoggedIn(bool loggedIn, {String? userType}) {
    _loggedIn = loggedIn;
    _userType = userType;
    notifyListeners();
  }

  void stopShowingSplashImage() {
    if (showSplashImage) {
      showSplashImage = false;
      notifyListeners();
    }
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      
      // ✅ ELIMINADO COMPLETAMENTE EL BLOQUE REDIRECT - EVITA LOOPS
      // redirect: (context, state) => null, // ❌ REMOVED
      
      errorBuilder: (context, state) {
        // ✅ ERROR BUILDER MEJORADO
        return LoginWidget();
      },
      
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => Builder(
            // ✅ SPLASH SIMPLE - SIN LÓGICA CONDICIONAL COMPLEJA
            builder: (context) => Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/Splash_Screen.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        FFRoute(
          name: 'CatalogoPublico',
          path: '/catalogoPublico/:userId',
          builder: (context, params) => CatalogoPublicoWidget(
            userIdVendedor: params.getParam('userId', ParamType.String)!,
          ),
        ),

        FFRoute(
          name: 'GenerarQr',           // ← DEBE COINCIDIR CON routeName
          path: '/generarQr',          // ← DEBE COINCIDIR CON routePath  
          builder: (context, params) => GenerarQrWidget(),
        ),

        FFRoute(
          name: 'MiCatalogo',           // ← DEBE COINCIDIR CON routeName
          path: '/miCatalogo',          // ← DEBE COINCIDIR CON routePath
          builder: (context, params) => MiCatalogoWidget(),
        ),

        FFRoute(
          name: SosWidget.routeName,
          path: SosWidget.routePath,
          builder: (context, params) => SosWidget(),
        ),
        FFRoute(
          name: QRVerificationWidget.routeName,
          path: QRVerificationWidget.routePath,
          builder: (context, params) => QRVerificationWidget(),
        ),
        FFRoute(
          name: NotificationsWidget.routeName,
          path: NotificationsWidget.routePath,
          builder: (context, params) => NotificationsWidget(),
        ),
        FFRoute(
          name: LoginWidget.routeName,
          path: LoginWidget.routePath,
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: OpcionDeRegistroWidget.routeName,
          path: OpcionDeRegistroWidget.routePath,
          builder: (context, params) => OpcionDeRegistroWidget(),
        ),
        FFRoute(
          name: RegistroClienteWidget.routeName,
          path: RegistroClienteWidget.routePath,
          builder: (context, params) => RegistroClienteWidget(),
        ),
        FFRoute(
          name: RegistroVendedorWidget.routeName,
          path: RegistroVendedorWidget.routePath,
          builder: (context, params) => RegistroVendedorWidget(),
        ),
        FFRoute(
          name: HomeWidget.routeName,
          path: HomeWidget.routePath,
          builder: (context, params) => HomeWidget(),
        ),
        FFRoute(
          name: EditarPerfilUsuarioWidget.routeName,
          path: EditarPerfilUsuarioWidget.routePath,
          builder: (context, params) => EditarPerfilUsuarioWidget(),
        ),
        FFRoute(
          name: ProfileUserWidget.routeName,
          path: ProfileUserWidget.routePath,
          builder: (context, params) => ProfileUserWidget(),
        ),
        FFRoute(
          name: PerfilVendedorWidget.routeName,
          path: PerfilVendedorWidget.routePath,
          builder: (context, params) => PerfilVendedorWidget(),
        ),
        FFRoute(
          name: ProfileUserInvitadoWidget.routeName,
          path: ProfileUserInvitadoWidget.routePath,
          builder: (context, params) => ProfileUserInvitadoWidget(),
        ),
        FFRoute(
          name: HomeInvitadoWidget.routeName,
          path: HomeInvitadoWidget.routePath,
          builder: (context, params) => HomeInvitadoWidget(),
        ),
        FFRoute(
          name: EditarPerfilVendedorWidget.routeName,
          path: EditarPerfilVendedorWidget.routePath,
          builder: (context, params) => EditarPerfilVendedorWidget(),
        ),
        FFRoute(
          name: AnadirProductoWidget.routeName,
          path: AnadirProductoWidget.routePath,
          builder: (context, params) => AnadirProductoWidget(),
        ),
        FFRoute(
          name: SignAccesoWidget.routeName,
          path: SignAccesoWidget.routePath,
          builder: (context, params) => SignAccesoWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}