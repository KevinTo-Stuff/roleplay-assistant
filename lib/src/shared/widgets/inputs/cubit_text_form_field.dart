// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

/// A small helper that binds a text field to a specific slice of a Cubit's
/// state using [BlocSelector]. It updates an internal [TextEditingController]
/// when the selected state value changes so the field content stays in sync.
///
/// Generic types:
/// - C: Cubit type
/// - S: Cubit state type
/// - T: selected value type (will be converted to/from string using toString())
class CubitTextFormField<C extends Cubit<S>, S, T> extends StatefulWidget {
  const CubitTextFormField({
    super.key,
    required this.label,
    required this.selector,
    required this.onChanged,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final T Function(S state) selector;
  final void Function(String value) onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  State<CubitTextFormField<C, S, T>> createState() =>
      _CubitTextFormFieldState<C, S, T>();
}

class _CubitTextFormFieldState<C extends Cubit<S>, S, T>
    extends State<CubitTextFormField<C, S, T>> {
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

  String _valueToString(T? v) => v == null ? '' : v.toString();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<C, S, T>(
      selector: widget.selector,
      builder: (BuildContext context, T value) {
        // Synchronize controller text after build to avoid layout issues
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final String newText = _valueToString(value);
          if (_controller.text != newText) {
            _controller.text = newText;
            _controller.selection =
                TextSelection.collapsed(offset: newText.length);
          }
        });

        return TextFormField(
          controller: _controller,
          decoration: InputDecoration(labelText: widget.label),
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          validator: widget.validator,
          onChanged: widget.onChanged,
        );
      },
    );
  }
}
