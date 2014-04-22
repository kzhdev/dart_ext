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
    Map one = { 'a': 'a', 'b': 'b', 'list': [{'one': 1}, {'two': 2}]};
    Map two = { 'a': 'A', 'b': 3, 'list': [{'two': 2}, {'three': 3}, 4]};
    Map three = merge(one, two);
    expect(three, equals({'a': 'A', 'b': 3, 'list': [{'one': 1, 'two': 2}, {'two': 2, 'three': 3}, 4]}));

    // changing merged map shouldn't change original maps
    three['b'] = 'B';
    expect(two['b'], equals(3));
    expect(one['b'], equals('b'));
  });
}