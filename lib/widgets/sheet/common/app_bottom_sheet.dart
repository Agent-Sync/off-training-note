import 'package:flutter/material.dart';

const Color kBottomSheetBackgroundColor = Colors.white;
const BorderRadius kBottomSheetBorderRadius = BorderRadius.vertical(
  top: Radius.circular(24),
);
const EdgeInsets kBottomSheetContentPadding = EdgeInsets.only(
  top: 24,
  left: 24,
  right: 24,
  bottom: 24,
);

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: builder,
  );
}

class AppBottomSheetContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool useKeyboardInset;

  const AppBottomSheetContainer({
    super.key,
    required this.child,
    this.padding = kBottomSheetContentPadding,
    this.useKeyboardInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = useKeyboardInset ? mediaQuery.viewInsets.bottom : 0.0;
    final content = child;
    return Container(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height),
      padding: padding.add(EdgeInsets.only(bottom: bottomInset)),
      decoration: BoxDecoration(
        color: kBottomSheetBackgroundColor,
        borderRadius: kBottomSheetBorderRadius,
      ),
      child: content,
    );
  }
}
