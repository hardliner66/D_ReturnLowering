# D_ReturnLowering
**Disclaimer:**
**Experimental code ahead. Don't use this in production.**

In the last two days i was thinking about why there is no overloading based on return type and how hard it would be to implement.

I remembered that I read about code lowering in some article or blog post about d, so I wanted to try something similiar. Instead of using a return value, one could use an out value.

So the following code:
```
int someFunction() {
  return 5;
}

string someFunction() {
  return "Test";
}
```

becomes:
```
void someFunction(out int _RANDOM_IDENTIFIER_0) {
  _RANDOM_IDENTIFIER_0 = 5;
  return;
}

void someFunction(out string _RANDOM_IDENTIFIER_0) {
  _RANDOM_IDENTIFIER_0 "Test";
  return;
}
```
which is clearly overloadable.


While implementing this, I also recognized that one could implement multiple return values the same way. So I tried that too.

Now, with the help of mixins, I implemented both. (see [app.d](source/app.d) for some examples)

Only two things are not implemented:
Ignoring of a return value and assigning to a variable with type auto. For this I'm missing some information about the argument types of the function that will be called.

Maybe I will rearchitecture this one day, but for a simple POC it's good enough :)

P.S.: I also found out that a call to a function with an out parameter is slightly faster than the same call with the return parameter. This may has to do with the calling convention, but I didn't research this enough to make a definite statement about it.
