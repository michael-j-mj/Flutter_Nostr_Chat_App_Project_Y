import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/repo/repo.dart';
import 'package:flutter_y_nostr/ui/auth/cubit/auth_cubit.dart';
import 'package:flutter_y_nostr/ui/home/bloc/home_bloc.dart';
import 'package:flutter_y_nostr/ui/home/views/home_view.dart';
import 'package:flutter_y_nostr/ui/signup/cubit/signup_cubit.dart';
import 'package:flutter_y_nostr/ui/signup/view/signup_view.dart';

var theme = ColorScheme.fromSeed(seedColor: Colors.blueGrey);

class MyApp extends StatelessWidget {
  final Repo repo;
  const MyApp(this.repo, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
          create: (context) => AuthCubit(repo), child: const AppView()),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO UPDATE WITH GO ROUTER
    context.read<AuthCubit>().loadData();

    return MaterialApp(
      title: 'Flutter Y',
      theme: ThemeData().copyWith(
        colorScheme: theme,
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        if (state is AuthLoggedIn) {
          return BlocProvider(
            create: (context) => HomeBloc(RepositoryProvider.of<Repo>(context))
              ..add(HomeEventLoad()),
            child: const HomeView(),
          );
        } else if (state is AuthLoggedOut) {
          return BlocProvider(
            create: (context) => SignupCubit(),
            child: const SignupView(),
          );
        } else {
          return const CircularProgressIndicator();
        }
      }),
    );
  }
}
