import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auto_disposable_tab_bar_view.dart';

class TabBarViewBodyImpl extends TabBarViewBody {
  const TabBarViewBodyImpl({
    required super.key,
    required super.scrollChildrenBaseKey,
    required super.isVisible,
    required super.state,
  });

  @override
  Widget buildParentView(
      BuildContext context, WidgetRef ref, Widget scrollView, state) {
    return scrollView;
  }

  @override
  Widget buildScrollView(BuildContext context, WidgetRef ref,
      List<Widget> scrollViewChildren, state) {
    return ListView.builder(
      itemCount: scrollViewChildren.length,
      itemBuilder: (context, index) => scrollViewChildren[index],
    );
  }

  @override
  List<WantKeepAlivePair> buildScrollViewChildren(
      BuildContext context, WidgetRef ref, state) {
    const itemHeight = 150.0;
    const itemWidth = 100.0;
    const padding = EdgeInsets.all(8);

    final horizontalListView = SizedBox(
      height: itemHeight + padding.vertical,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 50,
        itemExtent: itemWidth + padding.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: itemHeight,
              width: itemWidth,
              color: Colors.green,
              child: Center(
                child: Text(index.toString()),
              ),
            ),
          );
        },
      ),
    );

    return List.generate(
      10,
          (index) => WantKeepAlivePair(
        true,
        horizontalListView,
      ),
    );
  }
}