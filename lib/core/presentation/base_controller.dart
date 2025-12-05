import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class BaseController<T> extends ChangeNotifier {
  T _state;
  final _stateController = StreamController<T>.broadcast();

  BaseController(this._state);

  T get state => _state;

  /// Stream of state changes for testing purposes
  Stream<T> get stream => _stateController.stream;

  @protected
  void emit(T newState) {
    if (_state != newState) {
      _state = newState;
      _stateController.add(newState);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }
}
