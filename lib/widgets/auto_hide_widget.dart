import 'package:flutter/material.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

class AutoHideWidget extends StatelessWidget {
  final Widget child;
  final double disappearOpacityValue;

  AutoHideWidget({
    @required this.child,
    this.disappearOpacityValue = 0.0,
  });

  static Future<void> _navBarDelay() => Future.delayed(kFastWaitDuration);

  @override
  Widget build(BuildContext context) => ListenableProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(true),
        builder: (context, _) {
          ValueNotifier<bool> vnVisibility = Provider.of(
            context,
            listen: false,
          );

          /* hide the widget after the delay - for the first time */
          _navBarDelay().then((value) => vnVisibility.value = false);

          return FocusableActionDetector(
            onShowHoverHighlight: (bool hovering) {
              if (hovering)
                /* show the app bar */
                vnVisibility.value = true;
              else
                /* hide the app bar after a delay */
                _navBarDelay().then((_) => vnVisibility.value = false);
            },
            child: Consumer<ValueNotifier<bool>>(
              builder: (_, vnVisibility, child) => AnimatedOpacity(
                curve: Curves.easeInOut,
                duration: kFastAnimationDuration,
                opacity: vnVisibility.value ? 1.0 : disappearOpacityValue,
                child: child,
              ),
              child: child,
            ),
          );
        },
      );
}
