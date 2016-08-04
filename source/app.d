import std.stdio;
import multi;

// declare a function with multiple return values
mixin(declare!("int, int <= switchValues(int a, int b)", q{
  return b, a;
}));
// gets translated to => 
version (none) {
  void switchValues(int a, int b, out int _RANDOM_RESULT_PREFIX_0, out int _RANDOM_RESULT_PREFIX_1) {
    return b, a;
  }
}

// declare two functions, overloaded by return value
mixin(declare!("int <= overloadByReturnType()", q{
  return 3;
}));

mixin(declare!("string <= overloadByReturnType()", q{
  return "text";
}));

void main()
{
  int a = 2, b = 1;

  mixin(call!("a, b = switchValues(a, b)"));
  // gets translated to => 
  version (none) {
    switchValues(a, b, /*out*/ a, /*out*/ b);
  }

  int c;
  mixin(call!("c = overloadByReturnType()"));
  mixin(call!("string d = overloadByReturnType()"));

  writefln("a = %d, b = %d, c = %d, d = %s", a, b, c, d);
}
