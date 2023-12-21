import 'package:universal_notifier/src/collections/collection.dart';

/// [Map] that just delegates all actions to a base and fires delegation callbacks, see [DelegationCollection]
abstract class DelegatingMap<K, V> extends DelegatingCollection<MapEntry<K, V>> implements Map<K, V> {
  final Map<K, V> _base;

  DelegatingMap() : _base = {};
  DelegatingMap.from(Map<K, V> map) : _base = map;

  // WRITE OPERATIONS

  @override
  void operator []=(K key, V value) {
    final old = _base[key];
    if (old != null) onRemove(MapEntry(key, old));

    _base[key] = value;
    onAdded(MapEntry(key, value));
  }

  @override
  void addAll(Map<K, V> other) {
    _base.addAll(other);
    other.entries.forEach(onAdded);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _base.addEntries(newEntries);
    newEntries.forEach(onAdded);
  }

  @override
  void clear() {
    _base.entries.forEach(onRemove);
    _base.clear();
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final contained = _base.containsKey(key);
    final o = _base.putIfAbsent(key, ifAbsent);

    if (!contained) onAdded(MapEntry(key, o));
    return o;
  }

  @override
  V? remove(Object? key) {
    final contained = _base.containsKey(key);
    if (contained) onRemove(MapEntry(key as K, _base[key] as V));

    return _base.remove(key);
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _base.entries.where((e) => test(e.key, e.value)).forEach(onRemove);
    _base.removeWhere(test);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final o = _base.update(key, update, ifAbsent: ifAbsent);
    onAdded(MapEntry(key, o));
    return o;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    final entries = _base.entries.toList();
    _base.updateAll(update);
    entries.forEach(onAdded);
  }

  // READ OPERATIONS

  @override
  V? operator [](Object? key) => _base[key];

  @override
  bool containsKey(Object? key) => _base.containsKey(key);

  @override
  bool containsValue(Object? value) => _base.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => _base.entries;

  @override
  void forEach(void Function(K key, V value) action) => _base.forEach(action);

  @override
  bool get isEmpty => _base.isEmpty;

  @override
  bool get isNotEmpty => _base.isNotEmpty;

  @override
  Iterable<K> get keys => _base.keys;

  @override
  Iterable<V> get values => _base.values;

  @override
  int get length => _base.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) => _base.map(convert);

  @override
  Map<RK, RV> cast<RK, RV>() => _base.cast<RK, RV>();
}