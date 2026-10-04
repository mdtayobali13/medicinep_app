import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/utils/app_log.dart';

final signInProvider = StateNotifierProvider<_SignInProvider, bool>((ref) {
  return _SignInProvider();
});

class _SignInProvider extends StateNotifier<bool> {
  _SignInProvider() : super(false);
  // final Ref _ref;

  Future signIn(String email, String password) async {
    try {
      state = true;
      // final response = await AuthRepository.instance.login(email: email, password: password);
      // _ref.invalidate(customerProfileProvider);
      // _ref.invalidate(vendorStoreProvider);
      // _ref.invalidate(vendorOrderNotifierProvider);
      // _ref.invalidate(vendorDashboard);
      state = false;
      // return response;
    } catch (e) {
      errorLog("Login", e);
      state = false;
      return false;
    }
  }
}
