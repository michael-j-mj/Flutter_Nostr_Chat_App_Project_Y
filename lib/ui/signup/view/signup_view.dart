import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_y_nostr/ui/auth/cubit/auth_cubit.dart';
import 'package:flutter_y_nostr/ui/signup/cubit/signup_cubit.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupConfirmed) {
            context.read<AuthCubit>().logIn(state.keychain, state.existingKey);
          }
        },
        builder: (_, state) {
          if (state is SignupConfirmed) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.flutter_dash,
                        size: 200,
                      ),
                      SvgPicture.asset(
                        'assets/images/y.svg', // Replace with the path to your SVG file
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: !(state is SignupNewAccount)
                        ? TextField(
                            onChanged: (value) {
                              context.read<SignupCubit>().input(value);
                            },
                            readOnly: (state is SignupNewAccount),
                            decoration: InputDecoration(
                              labelText: "nsec key",
                              errorText:
                                  (state is SignupLogin && state.keyisValid)
                                      ? null
                                      : 'Invalid password',
                            ),
                          )
                        : Text((state.nsec)),
                  ),
                  if (state is SignupNewAccount) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    copyRow(state, context)
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 200,
                      child: FloatingActionButton(
                          foregroundColor:
                              (state is SignupNewAccount) && !(state).hasCopied
                                  ? Colors.grey
                                  : Theme.of(context)
                                      .floatingActionButtonTheme
                                      .foregroundColor,
                          onPressed:
                              (state is SignupNewAccount) && !(state).hasCopied
                                  ? null
                                  : () {
                                      context.read<SignupCubit>().confirmKey();
                                    },
                          child: Container(
                              child: Text(!(state is SignupNewAccount)
                                  ? "Login"
                                  : "Submit")))),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<SignupCubit>().toggleType();
                      },
                      child: Text(
                          (state is SignupNewAccount) ? "Login" : "Create New"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget copyRow(SignupNewAccount state, BuildContext context) {
    return (state.hasCopied) == true
        ? const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_sharp,
                color: Colors.green,
              ),
            ],
          )
        : TextButton(
            onPressed: () async {
              context.read<SignupCubit>().copy();
              await Clipboard.setData(ClipboardData(text: state.nsec));

              // Show a snackbar to indicate the text is copied
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Text copied to clipboard'),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.copy,
                ),
                SizedBox(width: 10),
                Text(
                  'Copy',
                ),
              ],
            ),
          );
  }
}
