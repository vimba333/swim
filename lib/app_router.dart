import 'package:go_router/go_router.dart';
import 'package:swim/features/home/presentation/pages/home_page.dart';
import 'package:swim/features/survay/presentation/pages/survey_page.dart';
import 'package:swim/features/users/presentation/pages/users_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/surveys',
      builder: (context, state) => const SurveyPage(),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => const UsersPage(),
    ),
  ],
);
