import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artvier/api_app/api_user.dart';
import 'package:artvier/base/base_provider/base_notifier.dart';
import 'package:artvier/model_response/user/bookmark/bookmark_tag.dart';
import 'package:artvier/pages/user/collection/model/collections_filter_model.dart';
import 'package:artvier/pages/user/collection/provider/filter_provider.dart';

/// 收藏作品的标签
/// - 由于需要预存固定标签选项：《全部》、《未分类》，故将本Provider当作已加载成功数据的标签列表，用懒加载状态作判断代替首次加载状态。
final collectionsTagsProvider = StateNotifierProvider.autoDispose<CollectionsTagsNotifier, List<BookmarkTag>?>(
  (ref) {
    var model = ref.watch(collectionsFilterProvider);
    return CollectionsTagsNotifier(
      null,
      ref: ref,
      filterModel: model,
    );
  },
);

/// 收藏作品的标签
class CollectionsTagsNotifier extends BaseStateNotifier<List<BookmarkTag>?> {
  CollectionsTagsNotifier(super.state, {required super.ref, required this.filterModel});

  final CollectionsFilterModel filterModel;

  String? nextUrl;

  final CancelToken _cancelToken = CancelToken();

  @override
  void dispose() {
    if (!_cancelToken.isCancelled) _cancelToken.cancel();
    super.dispose();
  }

  /// 初始化数据
  /// 返回是否还有更多
  Future<bool> fetch() async {
    var result = await ApiUser(requester).collectionTags(filterModel.worksType, restrict: filterModel.restrict);
    nextUrl = result.nextUrl;
    state = result.bookmarkTags ?? [];

    return nextUrl != null;
  }

  /// 下一页
  Future<bool> next() async {
    if (nextUrl == null) return false;

    var result = await ApiUser(requester).nextTags(nextUrl!);
    nextUrl = result.nextUrl;
    state = [...state!, ...result.bookmarkTags ?? []];

    return nextUrl != null;
  }

  // /// 下拉刷新
  // Future<void> refresh() async {
  //   await fetch();
  // }

  /// 重试或者重新加载
  // Future<void> reload() async {
  //   // Set loading
  //   state = const CollectionTagsState.loading();
  //   // Reload
  //   await fetch();
  // }
}
