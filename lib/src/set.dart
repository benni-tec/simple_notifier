import 'dart:async';

import 'package:meta/meta.dart';
import 'package:universal_notifier/src/collections/set.dart';
import 'package:universal_notifier/src/notifier.dart';

/// This [NotifyingSet] notifies its listeners when an element is added or removed
class NotifyingSet<E> extends DelegatingSet<E> with ChangeNotifier {
  NotifyingSet() : super();
  NotifyingSet.from(Iterable<E> iterable) : super.from(iterable);

  @override
  @mustCallSuper
  void onAdded(E value) => notifyListeners();

  @override
  @mustCallSuper
  void onRemove(E value)=> notifyListeners();
}

/// This [CascadingSet] notifies its listeners when an element is added/removed or one of its children notifies
class CascadingSet<E extends Notifier> extends NotifyingSet<E> {
  final _subscriptions = <E, StreamSubscription>{};

  CascadingSet() : super();
  CascadingSet.from(Iterable<E> iterable) : super.from(iterable) {
    for (final e in this) {
      _subscriptions[e] = e.changes.listen(notifyListeners);
    }
  }

  @override
  void onAdded(E value) {
    _subscriptions[value] = value.changes.listen(notifyListeners);
    super.onAdded(value);
  }

  @override
  void onRemove(E value) {
    _subscriptions.remove(value)?.cancel();
    super.onRemove(value);
  }
}
