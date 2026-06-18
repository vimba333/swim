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

  static const _levels = [
    SwimmerType.elite,
    SwimmerType.advanced,
    SwimmerType.intermediate,
    SwimmerType.beginner,
  ];

  static const _sliderTicks = ['1:10', '1:30', '2:00'];

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

  String get _fmtMin => (_seconds ~/ 60).toString();
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

  Color _accentColor(SwimmerType? level) => switch (level) {
        SwimmerType.elite => const Color(0xFFFFD700),
        SwimmerType.advanced => const Color(0xFF4DA6FF),
        SwimmerType.intermediate => const Color(0xFF00E096),
        SwimmerType.beginner => const Color(0xFFAAAAAA),
        null => const Color(0xFF4DA6FF),
      };

  String _levelLabel(SwimmerType type) => switch (type) {
        SwimmerType.elite => 'Elite',
        SwimmerType.advanced => 'Advanced',
        SwimmerType.intermediate => 'Intermediate',
        SwimmerType.beginner => 'Beginner',
      };

  @override
  Widget build(BuildContext context) {
    final level = SwimmerLevel(seconds: _seconds).swimmerType;
    final accent = _accentColor(level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // YOUR PACE
        const Text(
          'YOUR PACE',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white38,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),

        // MIN : SEC
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TimeUnit(
              controller: _minController,
              focusNode: _minFocusNode,
              onIncrement: () => _updateSeconds(_seconds + 60),
              onDecrement: () => _updateSeconds(_seconds - 60),
            ),
            // Двоеточие с квадратиками
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: accent,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 10,
                    height: 10,
                    color: accent,
                  ),
                ],
              ),
            ),
            _TimeUnit(
              controller: _secController,
              focusNode: _secFocusNode,
              onIncrement: () => _updateSeconds(_seconds + 1),
              onDecrement: () => _updateSeconds(_seconds - 1),
              maxValue: 59,
            ),
          ],
        ),

        // MIN : SEC / 100M
        const SizedBox(height: 8),
        const Text(
          'MIN  :  SEC  /  100M',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white38,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 32),

        // THAT PUTS YOU AT
        const Text(
          'THAT PUTS YOU AT',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white38,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            key: ValueKey(level),
            level != null ? _levelLabel(level) : '—',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Уровни над слайдером
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _levels.map((l) {
            final isActive = l == level;
            return Text(
              _levelLabel(l),
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.white : Colors.white38,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),

        // Слайдер
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accent,
            inactiveTrackColor: Colors.white12,
            thumbColor: accent,
            overlayColor: accent.withOpacity(0.15),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
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

        // Метки слайдера
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _sliderTicks
                .map((t) => Text(
                      t,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white38,
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 40),

        // Continue
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: widget.isLoading ? accent.withOpacity(0.5) : accent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: TextButton(
            onPressed: widget.isLoading
                ? null
                : () => widget.onSubmit(SwimmerLevel(seconds: _seconds)),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.black, size: 18),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int? maxValue;

  const _TimeUnit({
    required this.controller,
    required this.focusNode,
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
          icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 32),
          color: Colors.white54,
          onPressed: () {
            focusNode.unfocus();
            onIncrement();
          },
        ),
        TapRegion(
          onTapOutside: (_) => focusNode.unfocus(),
          child: SizedBox(
            width: 110,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              contextMenuBuilder: (context, _) => const SizedBox.shrink(),
              onSubmitted: (_) {
                focusNode.unfocus();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                if (maxValue != null) _MaxValueFormatter(maxValue!),
              ],
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          color: Colors.white54,
          onPressed: () {
            focusNode.unfocus();
            onDecrement();
          },
        ),
        const Text(
          'TAP TO EDIT',
          style: TextStyle(
            fontSize: 9,
            color: Colors.white24,
            letterSpacing: 1.5,
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