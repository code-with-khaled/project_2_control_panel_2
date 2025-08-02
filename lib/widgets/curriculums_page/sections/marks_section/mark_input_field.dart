import 'dart:async';

import 'package:flutter/material.dart';

class MarkInputField extends StatefulWidget {
  final int initialValue;
  // final ValueChanged<int>? onChanged;

  const MarkInputField({
    super.key,
    this.initialValue = 0,
    // this.onChanged,
  });

  @override
  State<MarkInputField> createState() => _MarkInputFieldState();
}

class _MarkInputFieldState extends State<MarkInputField> {
  late TextEditingController _controller;
  late int _value;
  Timer? _incrementTimer;
  Timer? _decrementTimer;
  bool _isIncrementing = false;
  bool _isDecrementing = false;
  bool _isHovered = false;
  bool _isEditing = false;

  final int maxValue = 100;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = TextEditingController(text: _value.toString());
    _controller.addListener(
      _filterNonNumericInput,
    ); // Add listener for input filtering
  }

  @override
  void dispose() {
    _incrementTimer?.cancel();
    _decrementTimer?.cancel();
    _controller.removeListener(_filterNonNumericInput); // Remove listener
    super.dispose();
  }

  // Filter out non-numeric characters while typing
  void _filterNonNumericInput() {
    final text = _controller.text;
    if (text.isEmpty) return;

    // Remove any non-digit characters
    final newText = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText != text) {
      final cursorPos = _controller.selection.baseOffset;
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(
        offset: cursorPos > newText.length
            ? newText.length
            : cursorPos - (text.length - newText.length),
      );
    }
  }

  // Handle editing completion
  void _completeEditing() {
    setState(() {
      _isEditing = false;
      // Parse the controller text to integer
      final parsedValue = int.tryParse(_controller.text) ?? 0;
      // Ensure value stays within bounds
      _value = parsedValue.clamp(0, maxValue);
      // Update controller text with the validated value
      _controller.text = _value.toString();
    });
    // widget.onChanged?.call(_value); // Uncomment if you want to use the callback
  }

  void _increment() {
    setState(() {
      if (_value < maxValue) _value++;
    });
    // widget.onChanged?.call(_value);
  }

  void _decrement() {
    if (_value > 0) {
      setState(() {
        _value--;
      });
      // widget.onChanged?.call(_value);
    }
  }

  void _startIncrementing() {
    _incrementTimer?.cancel();
    setState(() => _isIncrementing = true);

    // First increment immediately
    _increment();

    // Then start timer for continuous increment
    _incrementTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _increment();
    });
  }

  void _startDecrementing() {
    _decrementTimer?.cancel();
    setState(() => _isDecrementing = true);

    // First decrement immediately
    _decrement();

    // Then start timer for continuous decrement
    _decrementTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _decrement();
    });
  }

  void _stopTimers() {
    _incrementTimer?.cancel();
    _decrementTimer?.cancel();
    if (_isIncrementing || _isDecrementing) {
      setState(() {
        _isIncrementing = false;
        _isDecrementing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _isEditing = true),
        child: Container(
          padding: !_isEditing
              ? EdgeInsets.symmetric(vertical: 9, horizontal: 2)
              : EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onEditingComplete: _completeEditing,
                        onSubmitted: (_) => _completeEditing(),
                      )
                    : Text(
                        _value.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              SizedBox(width: 20),
              AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _increment(),
                      onTapDown: (_) => _startIncrementing(),
                      onTapUp: (_) => _stopTimers(),
                      onTapCancel: _stopTimers,
                      child: Icon(Icons.arrow_drop_up, size: 15),
                    ),
                    GestureDetector(
                      onTap: () => _decrement(),
                      onTapDown: (_) => _startDecrementing(),
                      onTapUp: (_) => _stopTimers(),
                      onTapCancel: _stopTimers,
                      child: Icon(Icons.arrow_drop_down, size: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
