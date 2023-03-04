import 'package:flutter/material.dart';

class FunctionController<T> {
  final Map<Key, ValueSetter<T>> _subscribers = {};

  Key register(ValueSetter<T> func) {
    final key = UniqueKey();
    _subscribers.putIfAbsent(key, () => func);
    return key;
  }

  void deregister(Key registerKey) {
    _subscribers.remove(registerKey);
  }

  void run(T t) {
    _subscribers.forEach((k, fn) => fn(t));
  }
}
