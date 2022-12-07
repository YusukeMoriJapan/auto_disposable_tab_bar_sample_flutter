import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

abstract class AutoDisposableTabBarView extends HookConsumerWidget {
  const AutoDisposableTabBarView({
    required this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
    Key? key,
  }) : super(key: key);
  final TabController controller;

  final ScrollPhysics? physics;

  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  List<Widget> buildTabBarViewBodies(
      BuildContext context, WidgetRef ref, int visiblePageIndex);

  ValueNotifier<int> _useInit() {
    final tabState = useState(controller.index);
    useEffect(() {
      listener() {
        final currentPage = controller.index;
        tabState.value = currentPage;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [true]);
    return tabState;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleTabIndex = _useInit();

    return TabBarView(
      key: key,
      controller: controller,
      physics: physics,
      dragStartBehavior: dragStartBehavior,
      viewportFraction: viewportFraction,
      clipBehavior: clipBehavior,
      children: buildTabBarViewBodies(
        context,
        ref,
        visibleTabIndex.value,
      ),
    );
  }
}

abstract class TabBarViewBody<T> extends HookConsumerWidget {
  const TabBarViewBody({
    required PageStorageKey key,
    required this.scrollChildrenBaseKey,
    required this.isVisible,
    required this.state,
  }) : super(key: key);

  final String scrollChildrenBaseKey;
  final bool isVisible;
  final T state;

  @protected
  List<WantKeepAlivePair> buildScrollViewChildren(
      BuildContext context, WidgetRef ref, T state);

  @protected
  Widget buildScrollView(BuildContext context, WidgetRef ref,
      List<Widget> scrollViewChildren, T state);

  @protected
  Widget buildParentView(
      BuildContext context, WidgetRef ref, Widget scrollView, T state);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollViewChildren = buildScrollViewChildren(context, ref, state)
        .mapIndexed(
          (i, e) => _AutomaticKeepAliveClientMixinWidget(
            key: PageStorageKey('$scrollChildrenBaseKey:row count $i'),
            wantKeepAlive: (isVisible && e.wantKeepAlive),
            child: e.widget,
          ),
        )
        .toList();

    final scrollView = HookConsumer(
      builder: (context, ref, children) => buildScrollView(
        context,
        ref,
        scrollViewChildren,
        state,
      ),
    );

    return buildParentView(
      context,
      ref,
      scrollView,
      state,
    );
  }
}

class WantKeepAlivePair {
  WantKeepAlivePair(this.wantKeepAlive, this.widget);

  final bool wantKeepAlive;
  final Widget widget;
}

class _AutomaticKeepAliveClientMixinWidget extends StatefulHookWidget {
  const _AutomaticKeepAliveClientMixinWidget(
      {super.key, required this.child, required this.wantKeepAlive});

  final Widget child;
  final bool wantKeepAlive;

  @override
  State<StatefulWidget> createState() =>
      _AutomaticKeepAliveClientMixinWidgetState();
}

class _AutomaticKeepAliveClientMixinWidgetState
    extends State<_AutomaticKeepAliveClientMixinWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final lastWantKeepAlive = useRef(widget.wantKeepAlive);

    if (lastWantKeepAlive.value != widget.wantKeepAlive) {
      updateKeepAlive();
    }

    lastWantKeepAlive.value = widget.wantKeepAlive;
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
