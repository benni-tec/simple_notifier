import 'dart:async';

import 'package:meta/meta.dart';

/// The basic stream-based [Notifier] contract used by this package
abstract class Notifier<T> {
  Stream<T> get changes;
}

/// Class/mixin that implements a [Notifier] as a [ChangeNotifier], this means listeners are notified of a change
/// but not what changes or how it did so!
mixin class ChangeNotifier implements Notifier<void> {
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  @protected
  void notifyListeners([void _]) => _changes.add(null);
}

/// Class/mixin that implements a [Notifier] as a [ValueNotifier], this means listeners are notified of a change and
/// the new value!
mixin class ValueNotifier<T> implements Notifier<T> {
  final _changes = StreamController<T>.broadcast();

  @override
  Stream<T> get changes => _changes.stream;

  @protected
  void notifyListeners(T value) => _changes.add(value);
}
