import 'package:flutter/material.dart';
import 'package:swim/features/survay/domain/entities/swimmer_level.dart';

class PaceEditor extends StatefulWidget {
  final SwimmerLevel initial;
  final ValueChanged<SwimmerLevel> onSubmit;
  final bool isLoading;

  const PaceEditor({
    super.key,
    required this.initial,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<PaceEditor> createState() => _PaceEditorState();
}

class _PaceEditorState extends State<PaceEditor> {
  late double _seconds;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initial.seconds ?? SwimmerLevel.minSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_seconds.round()} sec',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
        ),
        Slider(
          value: _seconds.clamp(SwimmerLevel.minSeconds, SwimmerLevel.maxSeconds),
          min: SwimmerLevel.minSeconds,
          max: SwimmerLevel.maxSeconds,
          onChanged: (val) => setState(() => _seconds = val),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () => widget.onSubmit(SwimmerLevel(seconds: _seconds)),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Continue'),
          ),
        ),
      ],
    );
  }
}