#dart_ext
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

###Object
####dynamic clone(dynamic source)
return a clone of the specified object

###Function
####relaxFn(Function function)
An funtion wrapper which support flexable number of arguments

####bind(Function functoin, List args)
Partially apply a function by filling in 0 to 5 number of its arguments;
* `function` - The function with partially filled args
* `args` - A List of prefilled args.

Example:
```
    Function add = (num a, num b) { return a + b; };
    var add5 = new bind(add, [5]);
    num rt = add5(6);
```

####invokeMethod(var target, String methodName, [arg0, arg1, arg2, arg3, arg4, arg5])
Invoke the given method in the target object.
* `target` - the object where the mehtod invoked from
* 'methodName` - the function name
* `[arg0, arg1, arg2, arg3, arg4, arg5]` - optional arguments. Suport 0 to 6 args.
Exception: if the method didn't exist in the target object, it throws 

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

####Map merge(Map map1, others, {Function iterableMergeFunc})
Merge maps into a new map.
* others - can be a Map or a list<Map>
* iterableMergeFunc - a custom merge function to override default iterable merge behavior
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
  
  Map three = {
    'a': 'A',
    'b': 4,
    'list': [{ 'three': 3 }, { 'four': 4}, 5, 6]
  }
  
  Map merged = merge(one, two);
  // merged is:
  {
    'a': 'A',
    'b': 3,
    'list': [{'one': 1, 'two': 2}, {'two': 2, 'three': 3}, 4]
  }
  
  merged = merge(one, [two, three]);
  // merged is:
  {
    'a': 'A',
    'b': 4,
    'list': [{'one': 1, 'two': 2, 'three': 3}, {'two': 2, 'three': 3, 'four': 4}, 5, 6]
  }
  
  merged = merge(one, two, (target, other) {
    list<num> toReturn = [];
    
    void _merge(List l) {
        target.forEach((t) {
            if (t is Map) {
                t.forEach((k, v) {
                    if (toReturn.contains(v) == false) {
                        toReturn.add(v);
                    }
                });
            } else if (toReturn.contains(v) == false) {
                toReturn.add(v);
            }
        });
    }
    
    _merge(target);
    _merge(orther);
    return toReturn;
  });
  // merged is:
  {
    'a': 'A',
    'b': 3,
    'list': [1, 2, 3, 4]
  }
```
#####Note: 
  1. merge didn't check value type. 
  2. if the value was a Iterable, it merge items at the same index.


