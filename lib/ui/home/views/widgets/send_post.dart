import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_y_nostr/ui/home/bloc/home_bloc.dart';

class SendPost extends StatefulWidget {
  const SendPost({super.key});

  @override
  State<SendPost> createState() => _SendPostState();
}

class _SendPostState extends State<SendPost> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = context.read<HomeBloc>();
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BlocBuilder<HomeBloc, HomeState>(
              bloc: bloc,
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Enter Text',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Add the submit event to the bloc
                          bloc.add(HomeEventSendPost(content: controller.text));
                          Navigator.of(context).pop(); // Close the bottom sheet
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
