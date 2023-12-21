import 'package:universal_notifier/src/collections/collection.dart';

/// [Set] that just delegates all actions to a base and fires delegation callbacks, see [DelegationCollection]
abstract class DelegatingSet<E> extends DelegatingCollection<E> implements Set<E> {
  final Set<E> _base;

  DelegatingSet() : _base = {};
  DelegatingSet.from(Iterable<E> iterable) : _base = iterable.toSet();

  // WRITE OPERATIONS

  @override
  bool add(E value) {
    final o = _base.add(value);
    onAdded(value);
    return o;
  }

  @override
  void addAll(Iterable<E> elements) {
    final set = elements.toSet();
    _base.addAll(set);

  }

  @override
  void clear() {
    _base.forEach(onRemove);
    _base.clear();
  }

  @override
  bool remove(Object? value) {
    if (_base.contains(value)) {
      onRemove(value as E);
      return false;
    }
    return _base.remove(value);
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    elements.where(_base.contains).whereType<E>().forEach(onRemove);
    _base.removeAll(elements);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _base.where(test).forEach(onRemove);
    _base.removeWhere(test);
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _base.difference(elements.toSet()).forEach(onRemove);
    _base.retainAll(elements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _base.where((e) => !test(e)).forEach(onRemove);
    _base.removeWhere(test);
  }

  // READ OPERATIONS

  @override
  E get single => _base.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) => _base.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => _base.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _base.skipWhile(test);

  @override
  Iterable<E> take(int count) => _base.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _base.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => _base.toList(growable: true);

  @override
  Set<E> toSet() => _base.toSet();

  @override
  Set<E> union(Set<E> other) => _base.union(other);

  @override
  Iterable<E> where(bool Function(E element) test) => _base.where(test);

  @override
  Iterable<T> whereType<T>() => _base.whereType<T>();

  @override
  bool any(bool Function(E element) test) => _base.any(test);

  @override
  Set<R> cast<R>() => _base.cast<R>();

  @override
  bool contains(Object? value) => _base.contains(value);

  @override
  bool containsAll(Iterable<Object?> other) => _base.containsAll(other);

  @override
  Set<E> difference(Set<Object?> other) => _base.difference(other);

  @override
  E elementAt(int index) => _base.elementAt(index);

  @override
  bool every(bool Function(E element) test) => _base.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) => _base.expand(toElements);

  @override
  E get first => _base.first;

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) => _base.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) => _base.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _base.followedBy(other);

  @override
  void forEach(void Function(E element) action) => _base.forEach(action);

  @override
  Set<E> intersection(Set<Object?> other) => _base.intersection(other);

  @override
  bool get isEmpty => _base.isEmpty;

  @override
  bool get isNotEmpty => _base.isNotEmpty;

  @override
  Iterator<E> get iterator => _base.iterator;

  @override
  String join([String separator = ""]) => _base.join(separator);

  @override
  E get last => _base.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) => _base.lastWhere(test, orElse: orElse);

  @override
  int get length => _base.length;

  @override
  E? lookup(Object? object) => _base.lookup(object);

  @override
  Iterable<T> map<T>(T Function(E e) toElement) => _base.map(toElement);

  @override
  E reduce(E Function(E value, E element) combine) => _base.reduce(combine);
}