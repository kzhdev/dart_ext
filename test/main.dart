import 'package:unittest/unittest.dart';

import '../lib/dart_ext.dart';

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

  test('partial', () {
    Function callback = (arg0, arg1, arg2) {
      return '${arg0}, ${arg1}, ${arg2}';
    };

    partial p = new partial(callback, [1, 2]);
    String rt = p(3);
    expect(rt, isNotNull);
    List<String> parts = rt.split(', ');
    expect(parts.length, equals(3));
    expect(parts[0], equals('1'));
    expect(parts[1], equals('2'));
    expect(parts[2], equals('3'));
  });

  test('partial add', () {
    Function add = (num a, num b) { return a + b; };
    var add5 = new partial(add, [5]);
    num rt = add5(6);
    expect(rt, equals(11));
  });
}