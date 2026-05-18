import 'package:flutter/foundation.dart';

class FormFieldController<T> extends ValueNotifier<T?> {
  FormFieldController(this.initialValue) : super(initialValue);

  final T? initialValue;

  void reset() => value = initialValue;
  void update() => notifyListeners();
}

class FormListFieldController<T> extends FormFieldController<List<T>> {
  final List<T>? _initialListValue;

  FormListFieldController(super.initialValue)
      : _initialListValue = List<T>.from(initialValue ?? []);

  @override
  void reset() => value = List<T>.from(_initialListValue ?? []);
}
