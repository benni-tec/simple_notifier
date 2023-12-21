import 'dart:math';

import 'package:universal_notifier/src/collections/collection.dart';

/// [List] that just delegates all actions to a base and fires delegation callbacks, see [DelegationCollection]
abstract class DelegatingList<E> extends DelegatingCollection<E> implements List<E> {
  final List<E> _base;

  DelegatingList() : _base = [];
  DelegatingList.from(Iterable<E> iterable) : _base = iterable.toList();

  // WRITE-OPERATIONS

  @override
  set first(E value) {
    if (_base.isNotEmpty) onRemove(_base.first);
    _base.first = value;
    onAdded(value);
  }

  @override
  set last(E value) {
    if (_base.isNotEmpty) onRemove(_base.last);
    _base.last = value;
    onAdded(value);
  }

  @override
  set length(int newLength) {
    final diff = newLength - _base.length;
    if (diff < 0) {
      _base.skip(_base.length).forEach(onRemove);
    }

    _base.length = length;
  }

  @override
  void operator []=(int index, E value) {
    final old = _base.elementAtOrNull(index);
    if (old != null) onRemove(old);

    _base[index] = value;
    onAdded(value);
  }

  @override
  void insert(int index, E element) {
    _base.insert(index, element);
    onAdded(element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    final list = iterable.toList(growable: false);
    _base.insertAll(index, list);
    list.forEach(onAdded);
  }

  @override
  void add(E value) {
    _base.add(value);
    onAdded(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    final list = iterable.toList(growable: false);
    _base.addAll(list);
    list.forEach(onAdded);
  }


  @override
  void clear() {
    _base.forEach(onRemove);
    _base.clear();
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    final old = _base.sublist(start, end);
    old.forEach(onRemove);

    _base.fillRange(start, end, fillValue);
    onAdded(fillValue as E);
  }

  @override
  bool remove(Object? value) {
    if (!_base.contains(value)) return false;

    onRemove(value as E);
    return _base.remove(value);
  }

  @override
  E removeAt(int index) {
    onRemove(_base[index]);
    return _base.removeAt(index);
  }

  @override
  E removeLast() {
    onRemove(_base.last);
    return _base.removeLast();
  }

  @override
  void removeRange(int start, int end) {
    _base.sublist(start, end).forEach(onRemove);
    _base.removeRange(start, end);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _base.where(test).forEach(onRemove);
    _base.removeWhere(test);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    _base.sublist(start, end).forEach(onRemove);

    final list = replacements.toList(growable: false);
    _base.replaceRange(start, end, list);

    list.forEach(onAdded);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _base.where((e) => !test(e)).forEach(onRemove);
    _base.retainWhere(test);
  }


  @override
  void setAll(int index, Iterable<E> iterable) {
    final list = iterable.toList(growable: false);
    _base.sublist(index, list.length).forEach(onRemove);

    _base.setAll(index, list);

    list.forEach(onAdded);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _base.sublist(start, end).forEach(onRemove);

    final list = iterable.toList(growable: false);
    _base.setRange(start, end, list, skipCount);

    list.sublist(skipCount).forEach(onAdded);
  }

  // READ OPERATIONS

  @override
  E get first => _base.first;

  @override
  E get last => _base.last;

  @override
  int get length => _base.length;

  @override
  Iterable<E> get reversed => _base.reversed;

  @override
  List<E> operator +(List<E> other) => _base + other;

  @override
  E operator [](int index) => _base[index];

  @override
  E get single => _base.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) => _base.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => _base.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _base.skipWhile(test);

  @override
  List<E> sublist(int start, [int? end]) => _base.sublist(start, end);

  @override
  Iterable<E> take(int count) => _base.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _base.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => _base.toList(growable: growable);

  @override
  Set<E> toSet() => _base.toSet();

  @override
  Iterable<E> where(bool Function(E element) test) => _base.where(test);

  @override
  Iterable<T> whereType<T>() => _base.whereType<T>();

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) => _base.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) => _base.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _base.followedBy(other);

  @override
  void forEach(void Function(E element) action) => _base.forEach(action);

  @override
  Iterable<E> getRange(int start, int end) => _base.getRange(start, end);

  @override
  int indexOf(E element, [int start = 0]) => _base.indexOf(element, start);

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) => _base.indexWhere(test, start);

  @override
  bool get isEmpty => _base.isEmpty;

  @override
  bool get isNotEmpty => _base.isNotEmpty;

  @override
  Iterator<E> get iterator => _base.iterator;

  @override
  String join([String separator = ""]) => _base.join(separator);

  @override
  int lastIndexOf(E element, [int? start]) => _base.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) => _base.lastIndexWhere(test, start);

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) => _base.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E e) toElement) => _base.map(toElement);

  @override
  E reduce(E Function(E value, E element) combine) => _base.reduce(combine);

  @override
  bool any(bool Function(E element) test) => _base.any(test);

  @override
  Map<int, E> asMap() => _base.asMap();

  @override
  List<R> cast<R>() => _base.cast<R>();

  @override
  bool contains(Object? element) => _base.contains(element);

  @override
  E elementAt(int index) => _base[index];

  @override
  bool every(bool Function(E element) test) => _base.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) => _base.expand(toElements);

  // IN-PLACE OPERATIONS

  @override
  void shuffle([Random? random]) => _base.shuffle(random);

  @override
  void sort([int Function(E a, E b)? compare]) => _base.sort(compare);
}
