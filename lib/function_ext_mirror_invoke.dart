library dart_ext.function.mirror_invoke;

@MirrorsUsed(override: "*")
import 'dart:mirrors';

dynamic invokeMethod(dynamic target, String methodName, [arg0, arg1, arg2, arg3, arg4, arg5]) {
  InstanceMirror im = reflect(target);
  MethodMirror f = im.type.instanceMembers.values.firstWhere((m) {
    return (m is MethodMirror) && MirrorSystem.getName(m.simpleName) == methodName;
  });
  switch(f.parameters.length) {
    case 0:
      return im.invoke(f.simpleName, []).reflectee;
    case 1:
      return im.invoke(f.simpleName, [arg0]).reflectee;
    case 2:
      return im.invoke(f.simpleName, [arg0, arg1]).reflectee;
    case 3:
      return im.invoke(f.simpleName, [arg0, arg1, arg2]).reflectee;
    case 4:
      return im.invoke(f.simpleName, [arg0, arg1, arg2, arg3]).reflectee;
    case 5:
      return im.invoke(f.simpleName, [arg0, arg1, arg2, arg3, arg4]).reflectee;
    case 6:
      return im.invoke(f.simpleName, [arg0, arg1, arg2, arg3, arg4, arg5]).reflectee;
    default:
      throw "Unknown function type, expecting 0 to 6 args.";
  }
}