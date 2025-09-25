// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

/// Generic dropdown bound to a cubit's selected slice using [BlocSelector].
///
/// - C: Cubit type
/// - S: Cubit state type
/// - T: value type for dropdown items (can be nullable)
class CubitDropdownFormField<C extends Cubit<S>, S, T> extends StatelessWidget {
  const CubitDropdownFormField({
    super.key,
    required this.label,
    required this.items,
    required this.selector,
    required this.onChanged,
    this.itemLabel,
  });

  final String label;
  final List<T> items;
  final T? Function(S state) selector;
  final void Function(T? value) onChanged;
  final String Function(T value)? itemLabel;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<C, S, T?>(
      selector: selector,
      builder: (BuildContext context, T? value) {
        return DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(labelText: label),
          items: items
              .map((T i) => DropdownMenuItem<T>(
                    value: i,
                    child:
                        Text(itemLabel != null ? itemLabel!(i) : i.toString()),
                  ))
              .toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}
