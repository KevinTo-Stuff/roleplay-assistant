// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

/// Numeric field bound to a cubit's integer slice using [BlocSelector].
/// Keeps a controller synced and provides optional min/max validation.
class CubitNumberFormField<C extends Cubit<S>, S> extends StatefulWidget {
  const CubitNumberFormField({
    super.key,
    required this.label,
    required this.selector,
    required this.onChanged,
    this.validator,
    this.min,
    this.max,
  });

  final String label;
  final int Function(S state) selector;
  final void Function(int value) onChanged;
  final String? Function(String?)? validator;
  final int? min;
  final int? max;

  @override
  State<CubitNumberFormField<C, S>> createState() =>
      _CubitNumberFormFieldState<C, S>();
}

class _CubitNumberFormFieldState<C extends Cubit<S>, S>
    extends State<CubitNumberFormField<C, S>> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<C, S, int>(
      selector: widget.selector,
      builder: (BuildContext context, int value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final String newText = value.toString();
          if (_controller.text != newText) {
            _controller.text = newText;
            _controller.selection =
                TextSelection.collapsed(offset: newText.length);
          }
        });

        return TextFormField(
          controller: _controller,
          decoration: InputDecoration(labelText: widget.label),
          keyboardType: TextInputType.number,
          validator: (String? v) {
            if (widget.validator != null) {
              final String? r = widget.validator!(v);
              if (r != null) return r;
            }
            if (v == null || v.trim().isEmpty) return 'Required';
            final int? parsed = int.tryParse(v.trim());
            if (parsed == null) return 'Invalid number';
            if (widget.min != null && parsed < widget.min!) return 'Too small';
            if (widget.max != null && parsed > widget.max!) return 'Too large';
            return null;
          },
          onChanged: (String v) {
            final int val = int.tryParse(v) ?? 0;
            widget.onChanged(val);
          },
        );
      },
    );
  }
}
