import std.stdio;
import multi;

// declare a function with multiple return values
mixin(declare!(q{ int, int <= switchValues(int a, int b) }, q{
  return b, a;
}));
// gets translated to =>
version (none) {
  void switchValues(int a, int b, out int _RANDOM_RESULT_PREFIX_0, out int _RANDOM_RESULT_PREFIX_1) {
    _RANDOM_RESULT_PREFIX_0 = b;
    _RANDOM_RESULT_PREFIX_1 = a;
    return;
  }
}

// declare two functions, overloaded by return value
mixin(declare!(q{int <= overloadByReturnType()}, q{
  return 3;
}));

mixin(declare!(q{string <= overloadByReturnType()}, q{
  return "text";
}));

void main()
{
  int a = 2, b = 1;

  mixin(call!(q{a, b = switchValues(a, b)}));
  // gets translated to => 
  version (none) {
    switchValues(a, b, /*out*/ a, /*out*/ b);
  }

  int c;
  string d;
  mixin(call!(q{c = overloadByReturnType()}));
  mixin(call!(q{d = overloadByReturnType()}));

  writefln("a = %d, b = %d, c = %d, d = %s", a, b, c, d);
}
