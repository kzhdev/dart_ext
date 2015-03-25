library dart_ext.collection;

getValue(Map map, key, [defaultValue = null]) {
  _getDefaultValue(defaultValue) {
    if (defaultValue is Function) {
      return defaultValue();
    }
    return defaultValue;
  }
  if (map == null) {
    return _getDefaultValue(defaultValue);
  }

  var rt = map[key];
  return map.containsKey(key) ? rt : _getDefaultValue(defaultValue);
}

void setValue(Map map, key, value) {
  map[key] = value;
}

dynamic clone(dynamic source) {
  var rt;
  if (source is Map) {
    rt = {};
    source.forEach((k, v) {
      rt[k] = clone(v);
    });
  } else if (source is Iterable) {
    if (source is List) {
      rt = [];
    } else if (source is Set) {
      rt = new Set();
    }

    if (rt != null) {
      source.forEach((item) {
        rt.add(clone(item));
      });
    } else {
      rt = new Iterable.generate(source.length, (item) {
        return clone(item);
      });
    }
  } else {
    rt = source;
  }
  return rt;
}

Map merge(Map map1, others, {Function iterableMergeFunc: null}) {
  Map rt = map1 == null ? {} : clone(map1);

  Iterable _mergeIterable(mergeTo, Iterable itr) {
    List target = new List.from(mergeTo);
    int i = 0;
    for (; i < target.length && i < itr.length; i++) {
      var item = itr.elementAt(i);
      if (item is Map) {
        target[i] = merge(target[i], item);
      } else if (item is Iterable) {
        target[i] = _mergeIterable(target[i], item);
      } else {
        target[i] = item;
      }
    }

    if (i < target.length) {
        target.removeRange(i, target.length);
    } else {
        for (; i < itr.length; i++) {
          target.add(clone(itr.elementAt(i)));
        }
    }

    return itr is Set ? target.toSet() : target;
  }

  void _merge(Map map) {
    map.forEach((k, v) {
      if (rt.containsKey(k)) {
        if (v is Map) {
          rt[k] = merge(rt[k], map[k]);
        } else if (v is Iterable){
          if (iterableMergeFunc != null) {
              rt[k] = iterableMergeFunc(rt[k], v);
          } else {
              rt[k] = _mergeIterable(rt[k], v);
          }
        } else {
          rt[k] = v;
        }
      } else {
        rt [k] = clone(v);
      }
    });
  }

  if (others is Map) {
      _merge(others);
  } else if (others is Iterable<Map>) {
      others.forEach((o) {
          _merge(o);
      });
  }
  return rt;
}