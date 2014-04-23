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
}