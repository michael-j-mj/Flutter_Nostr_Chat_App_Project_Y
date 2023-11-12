import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/repo/repo.dart';
import 'package:flutter_y_nostr/ui/auth/cubit/auth_cubit.dart';
import 'package:flutter_y_nostr/ui/signup/cubit/signup_cubit.dart';
import 'package:flutter_y_nostr/ui/signup/view/signup_view.dart';

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
        create: (context) => AuthCubit(repo)..loadData(),
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
    //TODO UPDATE WITH GO ROUTER

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedIn) {
          //route to posts
        } else if (state is AuthLoggedOut) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SignupCubit(),
              child: const SignupView(),
            ),
          ));
        }
      },
      child: CircularProgressIndicator(),
    );
  }
}
