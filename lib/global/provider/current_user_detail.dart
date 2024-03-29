import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artvier/api_app/api_user.dart';
import 'package:artvier/base/base_provider/base_notifier.dart';
import 'package:artvier/global/provider/current_account_provider.dart';
import 'package:artvier/model_response/user/user_detail.dart';

/// 当前用户的详细信息
final globalCurrentUserDetailProvider = StateNotifierProvider.autoDispose<CurrentUserDetailNotifier, UserDetail?>((ref) {
  String? userId = ref.watch(globalCurrentAccountProvider)?.user.id;
  return CurrentUserDetailNotifier(null, ref: ref, userId: userId)..fetch();
});

/// 当前用户的详细信息
class CurrentUserDetailNotifier extends BaseStateNotifier<UserDetail?> {
  CurrentUserDetailNotifier(super.state, {required super.ref, required this.userId});

  final String? userId;

  Future<void> fetch() async {
    if (userId == null) return;
    var detail = await ApiUser(requester).userDetail(userId!);
    state = detail;
  }

  /// 失败后的重试
  Future<void> retry() async => await fetch();
}
