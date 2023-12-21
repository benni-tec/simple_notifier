import 'dart:async';

import 'package:meta/meta.dart';

/// The basic stream-based [Notifier] contract used by this package
abstract class Notifier<T> {
  Stream<T> get changes;

  @protected
  void notifyListeners();
}

/// Class/mixin that implements a [Notifier] as a [ChangeNotifier], this means listeners are notified of a change
/// but not what changes or how it did so!
mixin class ChangeNotifier implements Notifier<void> {
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  @override
  void notifyListeners() => _changes.add(null);
}
