import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/shared/custom_app_drawer.dart';
import 'package:flutter_y_nostr/ui/home/bloc/home_bloc.dart';
import 'package:flutter_y_nostr/ui/home/views/widgets/nostr_list.dart';
import 'package:flutter_y_nostr/ui/home/views/widgets/nostr_post_temp.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: const CustomAppDrawer(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            debugPrint("Rebuild " + state.toString());
            if (state is HomeLoaded) {
              return NostrList(events: state.events);
            }
            return Center(
                child: Column(
              children: [],
            ));
          },
        ),
      ),
    );
  }
}
