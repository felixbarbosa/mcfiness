import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  bool saveCredentials = false;

  @action
  void toggleSaveCredentials() => saveCredentials = !saveCredentials;
}