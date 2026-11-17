import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/models/staff_user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/entry_flow_provider.dart';
import '../../features/auth/presentation/screens/entry_flow_screens.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/sales/presentation/screens/pos_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';
import '../../features/storyboard/presentation/screens/storyboard_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  String? lastRedirectState;
  ref.listen(authProvider, (_, __) => refreshNotifier.refresh());
  ref.listen(firstRunWelcomeProvider, (_, __) => refreshNotifier.refresh());
  final router = GoRouter(
    initialLocation: '/startup',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final staffUser = ref.read(authProvider).value;
      final authStatus = ref.read(authStatusProvider);
      final welcomeState = ref.read(firstRunWelcomeProvider);
      final path = state.uri.path;
      final welcomeStatus = welcomeState.when(
        loading: () => 'loading',
        error: (_, __) => 'error',
        data: (completed) => completed ? 'completed' : 'new',
      );
      final redirectState = '$path auth=$authStatus welcome=$welcomeStatus';
      if (kDebugMode && redirectState != lastRedirectState) {
        developer.log(
          'Router redirect evaluated: $redirectState',
          name: 'mboapos.startup',
        );
        debugPrint(
            '[mboapos.startup] Router redirect evaluated: $redirectState');
        lastRedirectState = redirectState;
      }
      final protected = path == '/pos' ||
          path == '/inventory' ||
          path == '/reports' ||
          path == '/settings' ||
          path.startsWith('/sales');
      const entryRoutes = {
        '/startup',
        '/welcome',
        '/entry',
        '/login',
        '/register',
      };
      if (authStatus == AuthStatus.unknown ||
          authStatus == AuthStatus.error ||
          welcomeState.isLoading) {
        return path == '/startup' ? null : '/startup';
      }
      if (welcomeState.hasError) {
        return path == '/startup' ? null : '/startup';
      }
      if (staffUser != null && entryRoutes.contains(path)) return '/pos';
      if (staffUser == null) {
        final welcomeCompleted = welcomeState.requireValue;
        if (!welcomeCompleted && path != '/welcome') return '/welcome';
        if (welcomeCompleted && (path == '/welcome' || path == '/startup')) {
          return '/entry';
        }
        if (protected) return '/entry';
      }
      if (path == '/reports' &&
          staffUser != null &&
          !{
            StaffRole.owner,
            StaffRole.admin,
            StaffRole.manager,
            StaffRole.supervisor,
          }.contains(staffUser.role)) {
        return '/pos';
      }
      if (path == '/inventory' &&
          staffUser != null &&
          !{
            StaffRole.owner,
            StaffRole.admin,
            StaffRole.manager,
            StaffRole.supervisor,
          }.contains(staffUser.role)) {
        return '/pos';
      }
      if (path == '/settings' &&
          staffUser != null &&
          staffUser.role != StaffRole.owner &&
          staffUser.role != StaffRole.admin) {
        return '/pos';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) => const EntryStartupScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const EntryFlowLocalizations(
          child: WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: '/entry',
        builder: (context, state) => const EntryFlowLocalizations(
          child: EntryChoiceScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => EntryFlowLocalizations(
          child: LoginScreen(
            initialStaffMode: state.uri.queryParameters['mode'] != 'owner',
          ),
        ),
      ),
      GoRoute(
          path: '/register',
          builder: (context, state) => const EntryFlowLocalizations(
                child: RegistrationScreen(),
              )),
      GoRoute(
          path: '/storyboard',
          builder: (context, state) => const StoryboardScreen()),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/pos', builder: (context, state) => const PosScreen()),
          GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryScreen()),
          GoRoute(
              path: '/reports',
              builder: (context, state) => const ReportsScreen()),
          GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refreshNotifier.dispose();
  });
  return router;
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}
