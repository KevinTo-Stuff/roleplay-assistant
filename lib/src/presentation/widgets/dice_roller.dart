import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A single reusable die widget that animates when rolled.
///
/// Usage:
/// - Create a `GlobalKey<DieWidgetState>()` and pass it to this widget
///   if you want to trigger rolls from a parent widget.
class DieWidget extends StatefulWidget {
  const DieWidget({
    super.key,
    this.sides = 6,
    this.size = 64,
    this.color,
    this.textStyle,
    this.rollDuration = const Duration(milliseconds: 900),
  });

  final int sides;
  final double size;
  final Color? color;
  final TextStyle? textStyle;
  final Duration rollDuration;

  @override
  DieWidgetState createState() => DieWidgetState();
}

class DieWidgetState extends State<DieWidget>
    with SingleTickerProviderStateMixin {
  late int _value;
  late final AnimationController _controller;
  late final Animation<double> _flipAnim;
  late final Animation<double> _wobbleAnim;
  Timer? _ticker;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _value = 1;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _flipAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    _wobbleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Triggers a roll animation and returns the final value.
  Future<int> roll() async {
    // Start the animated flip and periodically update the face.
    _controller.forward(from: 0.0);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 70), (Timer _) {
      setState(() {
        _value = _rng.nextInt(widget.sides) + 1;
      });
    });

    // Wait for the requested roll duration, then finish the animation
    await Future.delayed(widget.rollDuration);

    _ticker?.cancel();
    // play a short settle animation
    await _controller.animateTo(1.0,
        duration: const Duration(milliseconds: 220), curve: Curves.easeOut);

    setState(() => _value = _rng.nextInt(widget.sides) + 1);
    return _value;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color bg = widget.color ?? theme.colorScheme.surface;
    final TextStyle textStyle = widget.textStyle ??
        theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          // flip progress 0..1 mapped to rotationX (0..pi*2)
          final double flip = _flipAnim.value;
          final double wobble = _wobbleAnim.value;

          // rotation around X-axis to give 3D flip feel
          final double rotX = flip * pi * 2;
          // small rotation around Z for wobble
          final double rotZ = sin(flip * pi * 2) * 0.08 * wobble;
          final double scale = 1.0 + (0.08 * wobble);

          // shadow intensity animates with wobble
          final double shadowBlur = 6 + (12 * wobble);
          final double shadowOffsetY = 3 + (6 * wobble);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(0.0, 0.0, 0.0)
              ..rotateX(rotX)
              ..rotateZ(rotZ)
              ..scale(scale),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(widget.size * 0.14),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18 * (1 - wobble / 2)),
                    blurRadius: shadowBlur,
                    offset: Offset(0, shadowOffsetY),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '$_value',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A high-level dice roller that composes multiple [DieWidget]s and
/// exposes a simple Roll button. Configure number of dice and sides.
class DiceRoller extends StatefulWidget {
  const DiceRoller({
    super.key,
    this.count = 2,
    this.sides = 6,
    this.dieSize = 64,
    this.spacing = 12,
    this.onComplete,
  });

  final int count;
  final int sides;
  final double dieSize;
  final double spacing;
  final void Function(List<int> results)? onComplete;

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {
  late final List<GlobalKey<DieWidgetState>> _keys;
  List<int> _lastResults = <int>[];
  bool _rolling = false;

  @override
  void initState() {
    super.initState();
    _keys = List.generate(
      widget.count,
      (int _) => GlobalKey<DieWidgetState>(),
    );
  }

  Future<void> _rollAll() async {
    if (_rolling) return;
    setState(() => _rolling = true);

    // Start rolls with a stagger so each die begins slightly after the
    // previous one for a nicer visual rhythm.
    final List<int> results = <int>[];
    for (int i = 0; i < _keys.length; i++) {
      final DieWidgetState? s = _keys[i].currentState;
      if (s != null) {
        // stagger start
        Future.delayed(Duration(milliseconds: 80 * i), () => s.roll());
      }
    }

    // Wait a safe upper bound: longest roll + stagger
    final int staggerMs = 80 * (_keys.length - 1).clamp(0, 999);
    await Future.delayed(Duration(
        milliseconds:
            widget.count > 0 ? (widget.count * 80) + 800 + staggerMs : 900));

    // Collect final values from keys
    for (final GlobalKey<DieWidgetState> k in _keys) {
      final DieWidgetState? s = k.currentState;
      if (s != null) results.add(s._value);
    }
    setState(() {
      _lastResults = results;
      _rolling = false;
    });
    widget.onComplete?.call(results);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> dice = List<Widget>.generate(widget.count, (int i) {
      return DieWidget(
        key: _keys[i],
        sides: widget.sides,
        size: widget.dieSize,
      );
    });

    final int total = _lastResults.fold<int>(0, (int a, int b) => a + b);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing,
          alignment: WrapAlignment.center,
          children: dice,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _rolling ? null : _rollAll,
              icon: const Icon(Icons.casino),
              label: Text(_rolling ? 'Rolling...' : 'Roll'),
            ),
            const SizedBox(width: 12),
            if (_lastResults.isNotEmpty)
              Text(
                'Total: $total',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ],
    );
  }
}
