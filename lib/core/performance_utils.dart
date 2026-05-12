import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// ============================================================
/// PERFORMANCE UTILS — Memory & performance optimization
/// ============================================================

class Debouncer {
  final Duration delay;
  Timer? _timer;
  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

class Throttle {
  final Duration interval;
  Timer? _timer;
  bool _isThrottled = false;
  Throttle({this.interval = const Duration(milliseconds: 300)});

  void run(VoidCallback action) {
    if (_isThrottled) return;
    action();
    _isThrottled = true;
    _timer = Timer(interval, () => _isThrottled = false);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class ImageCacheManager {
  static void optimize({int maxImages = 50, int maxSizeBytes = 30 * 1024 * 1024}) {
    PaintingBinding.instance.imageCache.maximumSize = maxImages;
    PaintingBinding.instance.imageCache.maximumSizeBytes = maxSizeBytes;
  }

  static void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}

class DeferredBuilder extends StatefulWidget {
  final WidgetBuilder builder;
  final Widget? placeholder;
  const DeferredBuilder({super.key, required this.builder, this.placeholder});

  @override
  State<DeferredBuilder> createState() => _DeferredBuilderState();
}

class _DeferredBuilderState extends State<DeferredBuilder> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return widget.placeholder ?? const SizedBox.shrink();
    return widget.builder(context);
  }
}

mixin LifecycleMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];

  void trackSubscription(StreamSubscription sub) => _subscriptions.add(sub);
  void trackTimer(Timer timer) => _timers.add(timer);
  void safeSetState(VoidCallback fn) { if (mounted) setState(fn); }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    for (final t in _timers) {
      t.cancel();
    }
    _subscriptions.clear();
    _timers.clear();
    super.dispose();
  }
}
