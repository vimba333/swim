import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swim/features/survay/domain/entities/swimmer_level.dart';
import 'package:swim/features/survay/domain/entities/swimmer_type.dart';

class SwimmerLevelEditor extends StatefulWidget {
  final SwimmerLevel initial;
  final ValueChanged<SwimmerLevel> onSubmit;
  final bool isLoading;

  const SwimmerLevelEditor({
    super.key,
    required this.initial,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<SwimmerLevelEditor> createState() => _SwimmerLevelEditorState();
}

class _SwimmerLevelEditorState extends State<SwimmerLevelEditor> {
  late double _seconds;
  late TextEditingController _minController;
  late TextEditingController _secController;
  bool _editingMin = false;
  bool _editingSec = false;

  late FocusNode _minFocusNode;
  late FocusNode _secFocusNode;

  static const _ticks = [70, 90, 120, 180, 240];

  @override
  void initState() {
    super.initState();
    _seconds = widget.initial.seconds ?? SwimmerLevel.minSeconds;
    _minController = TextEditingController(text: _fmtMin);
    _secController = TextEditingController(text: _fmtSec);
    _minFocusNode = FocusNode()
      ..addListener(() {
        if (_minFocusNode.hasFocus) {
          setState(() => _editingMin = true);
        } else {
          _onMinSubmit(_minController.text);
        }
      });
    _secFocusNode = FocusNode()
      ..addListener(() {
        if (_secFocusNode.hasFocus) {
          setState(() => _editingSec = true);
        } else {
          _onSecSubmit(_secController.text);
        }
      });
  }

  @override
  void dispose() {
    _minController.dispose();
    _secController.dispose();
    _minFocusNode.dispose();
    _secFocusNode.dispose();
    super.dispose();
  }

  String get _fmtMin => (_seconds ~/ 60).toString().padLeft(2, '0');
  String get _fmtSec => (_seconds.round() % 60).toString().padLeft(2, '0');

  void _updateSeconds(double val) {
    final clamped = val.clamp(SwimmerLevel.minSeconds, SwimmerLevel.maxSeconds);
    setState(() {
      _seconds = clamped;
      if (!_editingMin) _minController.text = _fmtMin;
      if (!_editingSec) _secController.text = _fmtSec;
    });
  }

  void _onMinSubmit(String val) {
    final m = int.tryParse(val) ?? _seconds ~/ 60;
    final s = _seconds.round() % 60;
    _updateSeconds((m * 60 + s).toDouble());
    setState(() => _editingMin = false);
  }

  void _onSecSubmit(String val) {
    final s = (int.tryParse(val) ?? 0).clamp(0, 59);
    final m = _seconds ~/ 60;
    _updateSeconds((m * 60 + s).toDouble());
    setState(() => _editingSec = false);
  }

  String _tickLabel(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }

  Color _accentColor(SwimmerType? level) => switch (level) {
    SwimmerType.elite => const Color(0xFFFFD700),
    SwimmerType.advanced => const Color(0xFF00C8FF),
    SwimmerType.intermediate => const Color(0xFF00E096),
    SwimmerType.beginner => const Color(0xFFAAAAAA),
    null => const Color(0xFF444444),
  };

  @override
  Widget build(BuildContext context) {
    final level = SwimmerLevel(seconds: _seconds).swimmerType;
    final accent = _accentColor(level);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // MIN : SEC
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TimeUnit(
              controller: _minController,
              focusNode: _minFocusNode,
              label: 'MIN',
              onIncrement: () => _updateSeconds(_seconds + 60),
              onDecrement: () => _updateSeconds(_seconds - 60),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w200,
                  color: Colors.white54,
                ),
              ),
            ),
            _TimeUnit(
              controller: _secController,
              focusNode: _secFocusNode,
              label: 'SEC',
              onIncrement: () => _updateSeconds(_seconds + 1),
              onDecrement: () => _updateSeconds(_seconds - 1),
              maxValue: 59,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Badge
        SwimmerLevelBadge(level: level),
        const SizedBox(height: 24),

        // Слайдер
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accent,
            inactiveTrackColor: Colors.white12,
            thumbColor: accent,
            overlayColor: accent.withOpacity(0.15),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _seconds.clamp(
              SwimmerLevel.minSeconds,
              SwimmerLevel.maxSeconds,
            ),
            min: SwimmerLevel.minSeconds,
            max: SwimmerLevel.maxSeconds,
            onChanged: (val) {
              _minFocusNode.unfocus();
              _secFocusNode.unfocus();
              _updateSeconds(val);
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _ticks
                .map(
                  (t) => Text(
                    _tickLabel(t),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 48),

        // Continue
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () => widget.onSubmit(SwimmerLevel(seconds: _seconds)),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: accent == const Color(0xFFAAAAAA)
                  ? Colors.black
                  : Colors.black,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : // Continue
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: widget.isLoading
                          ? accent.withOpacity(0.5)
                          : accent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextButton(
                      onPressed: widget.isLoading
                          ? null
                          : () => widget.onSubmit(
                              SwimmerLevel(seconds: _seconds),
                            ),
                      child: widget.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int? maxValue;

  final FocusNode focusNode;

  const _TimeUnit({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.onIncrement,
    required this.onDecrement,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 36),
          color: Colors.white54,
          onPressed: () {
            focusNode.unfocus();
            onIncrement();
          },
        ),
        TapRegion(
          onTapOutside: (tap) {
            focusNode.unfocus();
          },
          child: SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              contextMenuBuilder: (context, _) => const SizedBox.shrink(),
              onSubmitted: (val) {
                focusNode.unfocus();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                if (maxValue != null) _MaxValueFormatter(maxValue!),
              ],
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 36),
          color: Colors.white54,
          onPressed: () {
            focusNode.unfocus();
            onDecrement();
          },
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white38,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _MaxValueFormatter extends TextInputFormatter {
  final int max;
  _MaxValueFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final val = int.tryParse(newValue.text);
    if (val != null && val > max) return oldValue;
    return newValue;
  }
}


class SwimmerLevelBadge extends StatelessWidget {
  final SwimmerType? level;

  const SwimmerLevelBadge({super.key, required this.level});

  String get _label => switch (level) {
        SwimmerType.elite => 'Elite',
        SwimmerType.advanced => 'Advanced',
        SwimmerType.intermediate => 'Intermediate',
        SwimmerType.beginner => 'Beginner',
        null => '—',
      };

  Color get _color => switch (level) {
        SwimmerType.elite => const Color(0xFFFFD700),
        SwimmerType.advanced => const Color(0xFF00C8FF),
        SwimmerType.intermediate => const Color(0xFF00E096),
        SwimmerType.beginner => const Color(0xFFAAAAAA),
        null => const Color(0xFF444444),
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(_label),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _color, width: 1.5),
        ),
        child: Text(
          _label,
          style: TextStyle(
            color: _color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
