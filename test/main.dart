import 'package:unittest/unittest.dart';

import '../lib/collection_ext.dart';

void main() {
  test('merge', () {
    Map one = { 'a': 'a', 'b': 'b', 'list': [{'one': 1}, {'two': 2}]};
    Map two = { 'a': 'A', 'b': 3, 'list': [{'two': 2}, {'three': 3}, 4]};
    Map three = merge(one, two);
    expect(three, equals({'a': 'A', 'b': 3, 'list': [{'one': 1, 'two': 2}, {'two': 2, 'three': 3}, 4]}));
  });
}