import 'package:meta/meta.dart';

/// Abstract contract used by delegation collections with callbacks for added and removed elements
abstract class DelegatingCollection<E> {
  /// Always called after an element is added to this list
  @protected
  void onAdded(E value);

  /// Always called before an element is removed from this list
  @protected
  void onRemove(E value);
}