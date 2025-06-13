import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maize_guard_admin/features/home/presentation/bloc/home_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/page/homepage.dart';
import '../constant/route_constant.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: RouteConstant.welcomePageRoute,
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is AuthCheckSuccessState) {
            context.read<HomeBloc>().add(GetExpertsEvent());
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            return ManageExpertsPage();
          } else {
            return LoginPage();
          }
        });
      },
    ),
    GoRoute(
      path: '/login',
      name: RouteConstant.loginPageRoute,
      builder: (context, state) => LoginPage(),
    ),
  ],
);
