import 'dart:async';

import 'package:meta/meta.dart';
import 'package:universal_notifier/src/collections/map.dart';
import 'package:universal_notifier/src/notifier.dart';

/// This [NotifyingMap] notifies its listeners when an element is added or removed
class NotifyingMap<K, V> extends DelegatingMap<K, V> with ChangeNotifier {
  NotifyingMap() : super();
  NotifyingMap.from(Map<K, V> map) : super.from(map);

  @override
  void onAdded(MapEntry<K, V> value) => notifyListeners();

  @override
  void onRemove(MapEntry<K, V> value) => notifyListeners();
}

/// This [CascadingMap] notifies its listeners when an element is added/removed or one of its children notifies
class CascadingMap<K, V extends Notifier> extends NotifyingMap<K, V> {
  final _subscriptions = <K, StreamSubscription>{};

  CascadingMap() : super();
  CascadingMap.from(Map<K, V> map) : super.from(map) {
    for (final e in entries) {
      _subscriptions[e.key] = e.value.changes.listen((_) => notifyListeners());
    }
  }

  @override
  @mustCallSuper
  void onAdded(MapEntry<K, V> value) {
    _subscriptions[value.key] = value.value.changes.listen((_) => notifyListeners());
    super.onAdded(value);
  }

  @override
  @mustCallSuper
  void onRemove(MapEntry<K, V> value) {
    _subscriptions.remove(value.key)?.cancel();
    super.onRemove(value);
  }
}