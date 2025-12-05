import 'package:flutter/foundation.dart';

abstract class BaseController<T> extends ChangeNotifier {
  T _state;

  BaseController(this._state);

  T get state => _state;

  @protected
  void emit(T newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
}
