import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_y_nostr/shared/custom_app_drawer.dart';
import 'package:flutter_y_nostr/ui/home/bloc/home_bloc.dart';
import 'package:flutter_y_nostr/ui/home/views/widgets/nostr_list.dart';
import 'package:flutter_y_nostr/ui/home/views/widgets/nostr_post_temp.dart';
import 'package:flutter_y_nostr/ui/home/views/widgets/send_post.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomAppDrawer(),
        floatingActionButton: SendPost(),
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset(
                'assets/images/y.svg'), // Your custom icon here
            onPressed: () {
              // Open the drawer
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
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
