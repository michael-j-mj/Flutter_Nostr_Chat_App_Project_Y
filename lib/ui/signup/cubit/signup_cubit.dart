import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_y_nostr/utils/util.dart';
import 'package:nostr/nostr.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupLogin());
  void input(String input) {
    if (state is SignupLogin) {
      emit((state as SignupLogin).copyWith(keyInput: input));
    }
  }

  void copy() {
    if (state is SignupNewAccount) {
      emit((state as SignupNewAccount).copyWith(hasCopied: true));
    }
  }

  void toggleType() {
    if (state is SignupLogin) {
      emit(SignupNewAccount(
        nsec: Util.keyEncode(Keychain.generate().private, true),
      ));
    } else {
      emit(SignupLogin());
    }
  }

  void confirmKey() {
    if (state is SignupNewAccount) {
      final state = this.state as SignupNewAccount;

      Keychain keychain = Keychain(Util.keyDecode(state.nsec));
      emit(SignupConfirmed(keychain: keychain, existingKey: false));
    }
    if (state is SignupLogin) {
      final state = this.state as SignupLogin;
      try {
        Keychain keychain = Keychain(Util.keyDecode(state.keyInput));
        emit(SignupConfirmed(keychain: keychain, existingKey: true));
      } catch (e) {
        emit(state.copyWith(keyisValid: false));
      }
    }
  }
}
