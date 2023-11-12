part of 'signup_cubit.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupLogin extends SignupState {
  final String keyInput;
  final bool keyisValid;
  const SignupLogin({this.keyInput = "", this.keyisValid = true});

  @override
  List<Object> get props => [keyInput, keyisValid];
  SignupLogin copyWith({String? keyInput, bool? keyisValid}) {
    return SignupLogin(
        keyInput: keyInput ?? this.keyInput,
        keyisValid: keyisValid ?? this.keyisValid);
  }
}

final class SignupNewAccount extends SignupState {
  final String nsec;
  final bool hasCopied;

  const SignupNewAccount({
    required this.nsec,
    this.hasCopied = false,
  });

  @override
  List<Object> get props => [nsec, hasCopied == false];

  SignupNewAccount copyWith({String? nsec, bool? hasCopied}) {
    return SignupNewAccount(
      nsec: nsec ?? this.nsec,
      hasCopied: hasCopied ?? this.hasCopied,
    );
  }
}

final class SignupConfirmed extends SignupState {
  final Keychain keychain;
  final bool existingKey;
  const SignupConfirmed({required this.keychain, required this.existingKey});
  @override
  List<Object> get props => [keychain.private, existingKey];
}
