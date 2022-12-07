import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auto_disposable_tab_bar_view.dart';
import 'main.dart';
import 'tab_bar_view_body_impl.dart';

class AutoDisposableTabBarViewImpl extends AutoDisposableTabBarView {
  const AutoDisposableTabBarViewImpl({
    super.key,
    required super.controller,
  });

  @override
  List<Widget> buildTabBarViewBodies(
      BuildContext context, WidgetRef ref, int visiblePageIndex) {
    return List.generate(
      tabSize,
          (index) => TabBarViewBodyImpl(
        key: PageStorageKey('tabBarViewImpl:$index'),
        scrollChildrenBaseKey: 'hogeBaseKey',
        isVisible: visiblePageIndex == index,
        state: null,
      ),
    );
  }
}