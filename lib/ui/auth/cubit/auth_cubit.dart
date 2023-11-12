import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_y_nostr/repo/repo.dart';
import 'package:nostr/nostr.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  Repo _repo;
  AuthCubit(this._repo) : super(AuthInitial());
  void loadData() async {
    bool gotData = await _repo.load();
    emit(gotData ? AuthLoggedIn() : AuthLoggedOut());
  }

  void logIn(Keychain keychain, bool existingKey) {
    //fetch any existing data on realys
    //store profile on local
    // change to logged in
    emit(AuthLoggedIn());
  }

  void logut() {}
}
