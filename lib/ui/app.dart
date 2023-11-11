import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/repo/repo.dart';
import 'package:flutter_y_nostr/ui/auth/cubit/auth_cubit.dart';

var theme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

class MyApp extends StatelessWidget {
  final Repo repo;
  const MyApp(this.repo, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (context) => AuthCubit(),
        child: MaterialApp(
          title: 'Flutter Y',
          theme: ThemeData(
            colorScheme: theme,
            useMaterial3: true,
          ),
          home: AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Container();
      },
    );
  }
}
