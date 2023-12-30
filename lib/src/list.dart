import 'dart:async';

import 'package:meta/meta.dart';
import 'package:universal_notifier/src/collections/list.dart';
import 'package:universal_notifier/src/notifier.dart';

/// This [NotifyingList] notifies its listeners when an element is added or removed
class NotifyingList<E> extends DelegatingList<E> with ChangeNotifier {
  NotifyingList();
  NotifyingList.from(Iterable<E> iterable) : super.from(iterable);

  @override
  @mustCallSuper
  void onAdded(E value) => notifyListeners();

  @override
  @mustCallSuper
  void onRemove(E value) => notifyListeners();
}

/// This [CascadingList] notifies its listeners when an element is added/removed or one of its children notifies
class CascadingList<E extends Notifier> extends NotifyingList<E> {
  final _subscriptions = <E, StreamSubscription>{};

  CascadingList();
  CascadingList.from(Iterable<E> iterable) : super.from(iterable) {
    for (final e in this) {
      _subscriptions[e] = e.changes.listen(notifyListeners);
    }
  }

  @override
  void onAdded(E value) {
    if (!contains(value)) _subscriptions[value] = value.changes.listen(notifyListeners);
    super.onAdded(value);
  }

  @override
  void onRemove(E value) {
    if (where((e) => e == value).length <= 1) _subscriptions.remove(value)?.cancel();
    super.onRemove(value);
  }
}
