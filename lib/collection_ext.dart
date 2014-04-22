library dart_ext.collection;

dynamic getValue(Map map, key, [defaultValue = null]) {
  dynamic _getDefaultValue(defaultValue) {
    if (defaultValue is Function) {
      return defaultValue();
    }
    return defaultValue;
  }
  if (map == null) {
    return _getDefaultValue(defaultValue);
  }

  var rt = map[key];
  return rt == null ? _getDefaultValue(defaultValue) : rt;
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

Map merge(Map map1, Map map2, [Map map3 = null, Map map4 = null]) {
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
        target[i] = itr;
      }
    }

    for (; i < itr.length; i++) {
      target.add(clone(itr.elementAt(i)));
    }
    return itr is Set ? target.toSet() : target;
  }

  void _merge(Map map) {
    map.forEach((k, v) {
      if (rt.containsKey(k)) {
        if (v is Map) {
          rt[k] = merge(rt[k], map[k]);
        } else if (v is Iterable){
          rt[k] = _mergeIterable(rt[k], v);
        } else {
          rt[k] = v;
        }
      } else {
        rt [k] = clone(v);
      }
    });
  }

  if (map2 != null) {
    _merge(map2);
  }

  if (map3 != null) {
    _merge(map3);
  }
  if (map4 != null) {
    _merge(map4);
  }
  return rt;
}