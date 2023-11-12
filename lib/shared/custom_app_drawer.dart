import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/ui/auth/cubit/auth_cubit.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            width: 130,
            child: FloatingActionButton(
                onPressed: () {
                  context.read<AuthCubit>().logOut();
                },
                foregroundColor: Theme.of(context).colorScheme.error,
                child: const Text("LOG OUT")),
          )
        ],
      ),
    );
  }
}
