import 'package:unittest/unittest.dart';

import '../lib/dart_ext.dart';
import 'dart:math';

class A {
  String foo() {
    return 'A foo';
  }

  String bar() {
    return 'A bar';
  }
}

class B extends A{
  String foo() {
    return 'B foo';
  }
}

void main() {
  test('capitalize', () {
    String s = capitalize('internet');
    expect(s, equals('Internet'));
  });

  test('clone', (){
    Map a = {'one': 1, 'two': 2, 'map': {'one': 1, 'two': 2}};
    Map b = clone(a);
    expect(b, equals(a));
    b['two'] = 'two';
    b['map']['two'] = 'Two';
    expect(b, equals({'one': 1, 'two': 'two', 'map': {'one': 1, 'two': 'Two'}}));
    expect(a, equals({'one': 1, 'two': 2, 'map': {'one': 1, 'two': 2}}));
  });

  test('merge', () {
    Map one = { 'a': 'a', 'b': 'b', 'list': [{'one': 1}, {'two': 2}], 'list2': [1, 'a', 2, 'b']};
    Map two = { 'a': 'A', 'b': 3, 'list': [{'two': 2}, {'three': 3}, 4], 'list2': [1,2, 3, 4, 5, 6]};
    Map merged = merge(one, two);
    expect(merged, equals({'a': 'A', 'b': 3, 'list': [{'one': 1, 'two': 2}, {'two': 2, 'three': 3}, 4], 'list2': [1, 2, 3, 4, 5, 6]}));

    // changing merged map shouldn't change original maps
    merged['b'] = 'B';
    expect(two['b'], equals(3));
    expect(one['b'], equals('b'));
  });

  test('merge_multiple', () {
      Map one = { 'a': 'a', 'b': 'b', 'list': [{'one': 1}, {'two': 2}], 'list2': [1, 'a', 2, 'b']};
      Map two = { 'a': 'A', 'b': 3, 'list': [{'two': 2}, {'three': 3}, 4], 'list2': [1,2, 3, 4, 5, 6]};
      Map three = { 'a': 'A', 'b': 4, 'list': [{'three': 3}, {'four': 4}, 4, 5], 'list2': [7, 6, 5, 4]};
      Map merged = merge(one, [two, three]);
      expect(merged, equals({'a': 'A', 'b': 4, 'list': [{'one': 1, 'two': 2, 'three': 3}, {'two': 2, 'three': 3, 'four': 4}, 4, 5],
                            'list2': [7, 6, 5, 4]}));
  });

  test('mege_iterableMergeFunc', () {
      Map one = { 'a': 'a', 'b': 'b', 'list': 0, 'list2': [{'1': 1}, 1, 'a', 2, 'b', 5, 6]};
      Map two = { 'a': 'A', 'b': 3, 'list': [{'two': 2}, {'three': 3}, 4], 'list2': [{'2': 2}, 1, 2, 3, 4]};
      Function mergeIterable = (target, other) {
          _internalMerge(t, o) {
            if (t is Iterable) {
              var num = min(t.length, o.length);
              int i = 0;
              for (; i < num; i++) {
                if (t[i].runtimeType == o[i].runtimeType) {
                  if (t[i] is Map) {
                      t[i] = merge(t[i], o[i]);
                  } else if (t[i] is Iterable) {
                      t[i] = _internalMerge(t[i], o[i]);
                  } else {
                      t[i] = o[i];
                  }
                }
              }

              if (t.length < o.length) {
                  for (; i < o.length; i++) {
                    target.add(clone(o.elementAt(i)));
                  }
              }
            } else {
              t = o;
            }
            return t;
          }
        return _internalMerge(target, other);
      };
      Map merged = merge(one, two, iterableMergeFunc: mergeIterable);
      expect(merged, equals({'a': 'A', 'b': 3, 'list': [{'two': 2}, {'three': 3}, 4], 'list2': [{'1': 1, '2': 2}, 1, 'a', 3, 'b', 5, 6]}));
  });

  test('bind', () {
    Function callback = (arg0, arg1, arg2) {
      return '${arg0}, ${arg1}, ${arg2}';
    };

    bind b = new bind(callback, [1, 2]);
    String rt = b(3);
    expect(rt, isNotNull);
    List<String> parts = rt.split(', ');
    expect(parts.length, equals(3));
    expect(parts[0], equals('1'));
    expect(parts[1], equals('2'));
    expect(parts[2], equals('3'));
  });

  test('bind add', () {
    Function add = (num a, num b) { return a + b; };
    var add5 = new bind(add, [5]);
    num rt = add5(6);
    expect(rt, equals(11));
  });

  test('invoke method', (){
    A a = new A();
    var rt = invokeMethod(a, 'foo');
    expect(rt, equals('A foo'));
    rt = invokeMethod(a, 'bar');
    expect(rt, equals('A bar'));
    A b = new B();
    rt = invokeMethod(b, 'foo');
    expect(rt, equals('B foo'));
    rt = invokeMethod(b, 'bar');
    expect(rt, equals('A bar'));
    try {
      invokeMethod(a, 'print');
      throw 'print function should not exit';
    } catch(e) {
      expect(e.message, equals('No element'));
    }
  });
}