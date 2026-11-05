import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('ScrollThresholdConfig', () {
    test('default values are properly initialized', () {
      const config = ScrollThresholdConfig();
      expect(config.leadingStartOffset, 20.0);
      expect(config.leadingEndOffset, 80.0);
      expect(config.trailingStartOffset, 20.0);
      expect(config.trailingEndOffset, 80.0);
      expect(config.statusBarHideOffset, 100.0);
      expect(config.statusBarShowOffset, 50.0);
    });

    test('validates start and end offset ordering', () {
      expect(
        () => ScrollThresholdConfig(
          leadingStartOffset: 100.0,
          leadingEndOffset: 50.0,
        ),
        throwsAssertionError,
      );

      expect(
        () => ScrollThresholdConfig(
          trailingStartOffset: 90.0,
          trailingEndOffset: 30.0,
        ),
        throwsAssertionError,
      );

      expect(
        () => ScrollThresholdConfig(
          statusBarHideOffset: 40.0,
          statusBarShowOffset: 80.0,
        ),
        throwsAssertionError,
      );
    });

    test('copyWith updates specified fields', () {
      const original = ScrollThresholdConfig();
      final updated = original.copyWith(
        leadingStartOffset: 30.0,
        leadingEndOffset: 90.0,
        trailingStartOffset: 40.0,
        trailingEndOffset: 100.0,
        statusBarHideOffset: 120.0,
        statusBarShowOffset: 60.0,
      );

      expect(updated.leadingStartOffset, 30.0);
      expect(updated.leadingEndOffset, 90.0);
      expect(updated.trailingStartOffset, 40.0);
      expect(updated.trailingEndOffset, 100.0);
      expect(updated.statusBarHideOffset, 120.0);
      expect(updated.statusBarShowOffset, 60.0);
    });
  });

  group('ScrollAnimationConfig', () {
    test('default values are properly initialized', () {
      const config = ScrollAnimationConfig();
      expect(config.transitionType, ScrollTransitionType.scrollProgress);
      expect(config.duration, const Duration(milliseconds: 250));
      expect(config.curve, Curves.easeInOut);
      expect(config.minScale, 0.75);
      expect(config.maxScale, 1.0);
      expect(config.slideOffset, const Offset(0.0, 0.15));
      expect(config.enableFade, isTrue);
      expect(config.enableScale, isTrue);
      expect(config.enableSlide, isTrue);
      expect(config.enableReverseAnimation, isTrue);
      expect(config.effectiveReverseCurve, Curves.easeInOut);
    });

    test('copyWith updates specified fields', () {
      const original = ScrollAnimationConfig();
      final updated = original.copyWith(
        transitionType: ScrollTransitionType.thresholdTriggered,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.linear,
        minScale: 0.5,
        maxScale: 1.2,
        slideOffset: const Offset(0.0, 0.3),
        enableFade: false,
        enableScale: false,
        enableSlide: false,
        enableReverseAnimation: false,
      );

      expect(updated.transitionType, ScrollTransitionType.thresholdTriggered);
      expect(updated.duration, const Duration(milliseconds: 400));
      expect(updated.curve, Curves.fastOutSlowIn);
      expect(updated.reverseCurve, Curves.linear);
      expect(updated.effectiveReverseCurve, Curves.linear);
      expect(updated.minScale, 0.5);
      expect(updated.maxScale, 1.2);
      expect(updated.slideOffset, const Offset(0.0, 0.3));
      expect(updated.enableFade, isFalse);
      expect(updated.enableScale, isFalse);
      expect(updated.enableSlide, isFalse);
      expect(updated.enableReverseAnimation, isFalse);
    });
  });

  group('StatusBarConfig', () {
    test('default values are properly initialized', () {
      const config = StatusBarConfig();
      expect(config.enabled, isTrue);
      expect(config.hideOnScroll, isTrue);
      expect(config.preventContentJump, isTrue);
      expect(config.hiddenUiMode, SystemUiMode.manual);
      expect(config.hiddenOverlays, const [SystemUiOverlay.bottom]);
      expect(config.visibleUiMode, SystemUiMode.edgeToEdge);
      expect(config.restoreOnDispose, isTrue);
      expect(config.restoreOnRouteTransition, isTrue);
      expect(config.androidHiddenOverlayStyle, isNull);
      expect(config.androidVisibleOverlayStyle, isNull);
      expect(config.iosHiddenOverlayStyle, isNull);
      expect(config.iosVisibleOverlayStyle, isNull);
    });

    test('copyWith updates specified fields', () {
      const original = StatusBarConfig();
      const androidStyle = SystemUiOverlayStyle(statusBarColor: Colors.black);
      const iosStyle = SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      );

      final updated = original.copyWith(
        enabled: false,
        hideOnScroll: false,
        preventContentJump: false,
        hiddenUiMode: SystemUiMode.immersive,
        hiddenOverlays: [],
        restoreOnDispose: false,
        restoreOnRouteTransition: false,
        androidHiddenOverlayStyle: androidStyle,
        iosHiddenOverlayStyle: iosStyle,
      );

      expect(updated.enabled, isFalse);
      expect(updated.hideOnScroll, isFalse);
      expect(updated.preventContentJump, isFalse);
      expect(updated.hiddenUiMode, SystemUiMode.immersive);
      expect(updated.hiddenOverlays, isEmpty);
      expect(updated.restoreOnDispose, isFalse);
      expect(updated.restoreOnRouteTransition, isFalse);
      expect(updated.androidHiddenOverlayStyle, androidStyle);
      expect(updated.iosHiddenOverlayStyle, iosStyle);
      expect(
        updated.resolveHiddenOverlayStyle(TargetPlatform.android),
        androidStyle,
      );
      expect(updated.resolveHiddenOverlayStyle(TargetPlatform.iOS), iosStyle);
    });
  });

  group('PinnedActionsConfig', () {
    test('default values are properly initialized', () {
      const config = PinnedActionsConfig();
      expect(config.pinned, isTrue);
      expect(config.transparentBackground, isTrue);
      expect(config.height, 56.0);
      expect(
        config.padding,
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      );
      expect(config.touchTargetSize, const Size(48.0, 48.0));
      expect(config.safeArea, isTrue);
    });

    test('copyWith updates specified fields', () {
      const original = PinnedActionsConfig();
      final updated = original.copyWith(
        pinned: false,
        transparentBackground: false,
        height: 64.0,
        touchTargetSize: const Size(56.0, 56.0),
        safeArea: false,
      );

      expect(updated.pinned, isFalse);
      expect(updated.transparentBackground, isFalse);
      expect(updated.height, 64.0);
      expect(updated.touchTargetSize, const Size(56.0, 56.0));
      expect(updated.safeArea, isFalse);
    });
  });

  group('ScrollResponsiveConfig', () {
    test('reconciles convenience flags into effective configs', () {
      const config = ScrollResponsiveConfig(
        pinSideActions: false,
        transparentActions: false,
        hideStatusBarOnScroll: false,
        enableReverseAnimation: false,
      );

      expect(config.effectivePinnedActions.pinned, isFalse);
      expect(config.effectivePinnedActions.transparentBackground, isFalse);
      expect(config.effectiveStatusBar.hideOnScroll, isFalse);
      expect(config.effectiveAnimation.enableReverseAnimation, isFalse);
    });

    test('copyWith updates configurations cleanly', () {
      const original = ScrollResponsiveConfig();
      final updated = original.copyWith(
        pinSideActions: false,
        hideStatusBarOnScroll: false,
      );

      expect(updated.pinSideActions, isFalse);
      expect(updated.hideStatusBarOnScroll, isFalse);
      expect(updated.transparentActions, isTrue);
    });
  });
}
