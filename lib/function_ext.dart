library dart_ext.function;

typedef FnWith0Args();
typedef FnWith1Args(a0);
typedef FnWith2Args(a0, a1);
typedef FnWith3Args(a0, a1, a2);
typedef FnWith4Args(a0, a1, a2, a3);
typedef FnWith5Args(a0, a1, a2, a3, a4);
typedef FnWith6Args(a0, a1, a2, a3, a4, a5);
typedef FnWith7Args(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9);

Function relaxFn(Function fn) {
  if (fn is FnWith6Args) {
    return ([a0, a1, a2, a3, a4, a5]) => fn(a0, a1, a2, a3, a4, a5);
  } else if (fn is FnWith5Args) {
    return ([a0, a1, a2, a3, a4, a5]) => fn(a0, a1, a2, a3, a4);
  } else if (fn is FnWith4Args) {
    return ([a0, a1, a2, a3, a4, a5]) => fn(a0, a1, a2, a3);
  } else if (fn is FnWith3Args) {
    return ([a0, a1, a2, a3, a4, a5]) => fn(a0, a1, a2);
  } else if (fn is FnWith2Args) {
    return ([a0, a1, a2, a3, a4, a5]) => fn(a0, a1);
  } else if (fn is FnWith1Args) {
    return ([a0, a1, a2, a3, a4, a5]) => fn(a0);
  } else if (fn is FnWith0Args) {
    return ([a0, a1, a2, a3, a4, a5]) => fn();
  } else {
    return ([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]) {
      throw "Unknown function type, expecting 0 to 9 args.";
    };
  }
}

class partial {
  List _args;
  Function _callback;

  partial(Function function, List args) {
    _args = new List.from(args);
    if (args.length > 5) {
      throw 'partial support 0 to 5 args';
    }
    _callback = relaxFn(function);
  }

  call([arg0, arg1, arg2, arg3, arg4]) {
    switch(_args.length){
      case 0:
        return _callback(arg0, arg1, arg2, arg3, arg4);
        break;
      case 1:
        return _callback(_args[0], arg0, arg1, arg2, arg3, arg4);
        break;
      case 2:
        return _callback(_args[0], _args[1], arg0, arg2, arg3, arg4);
        break;
      case 3:
        return _callback(_args[0], _args[1], _args[2], arg0, arg1, arg2, arg3, arg4);
        break;
      case 4:
        return _callback(_args[0], _args[1], _args[2], _args[3], arg0, arg1, arg2, arg3, arg4);
        break;
      case 5:
        return _callback(_args[0], _args[1], _args[2], _args[3], _args[4], arg0, arg1, arg2, arg3, arg4);
        break;
      default:
        throw 'partial support 0 to 5 args';
    }
  }
}