import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize_guard_admin/core/route/route.dart';
import 'package:maize_guard_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:maize_guard_admin/features/auth/presentation/bloc/register_bloc.dart';
import 'package:maize_guard_admin/features/home/presentation/bloc/home_bloc.dart';

import 'dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => sl<AuthBloc>()..add(AuthCheckEvent())),
          BlocProvider(create: (context) => sl<HomeBloc>()),
          BlocProvider(
            create: (context) => sl<RegisterBloc>(),
          )
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Maize Guard Admin',
          routerConfig: router,
        ));
  }
}
