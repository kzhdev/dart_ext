#Dart_ext
A set of useful helper functions

##Installing

###1. Depend on it
Add this to your package's pubspec.yaml file:
```
  dependencies:
    dart_ext: any
```

###2. Install it
```
  run pub get in Dart Editor or form command line
```

###3. Import it
Add this line in your dart code:
```
  import 'package:dart_ext/dart_ext.dart';
```

##API

###String 
####String capitalize(String s)
return a capitalized string

###Map
####dynamic getValue(Map source, dynamic key, [defaultValue = null])
return the value of given key in the map. If the key didn't exit, return given defaultValue or null if defaultValue didn't represent.
* `source` - the map to get value from
* `key` - the key of the value to get
* `defaultValue` - the defaultValue to return if the key didn't exist in the map. `defaultValue can be a function`.

Example:
```
    Map m = {
      'one': 1,
      'two': 2
    }
    
    num two = getValue(m, 'two');       //  two = 2
    num zero = getValue(m, 'zero');     //  zero = null
    zero = getValue(m, 'zero', 0);      //  zero = 0
    num four = getValue(m, 'three', (){ return getValue(m, 'three', 3) + 1; });  // four = 4
```

####void setValue(Map source, dynamic key, dynamic value)
Add key/value to the given map. Equivalent to source[key] = value.
It is convenient to use in a setter which set a value in map.
```
  Map _config = {};
  
  void set name(String value) => setValue(_config, 'name', value);
```

####Map clone(Map source)
return a clone of the specified map

####Map merge(Map map1, Map map2, [Map map3, Map4])
Merge up to 4 maps into a new map.
```
  import 'package:dart_ext/collection_ext.dart';  // only import collection extension
  
  Map one = {
    'a': 'a',
    'b': 'b',
    'list': [{ 'one': 1 }, { 'two': 2 }]
  }
  
  Map two = {
    'a': 'A'
    'b': 3,
    'list': [{ 'two': 2 }, { 'three': 3 }, 4 ]
  }
  
  Map merged = merge(one, two);
  // mergee is:
  {
    'a': 'A',
    'b': 3,
    'list': [{'one': 1, 'two': 2}, {'two': 2, 'three': 3}, 4]
  }
```
#####Note: 1. merge didn't check value type. 
           2. if the value was a Iterable, it merge items at the same index.


