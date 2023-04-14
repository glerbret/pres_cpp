#include <iostream>

[[ nodiscard("Must be checked") ]] static int foo()
{
  return 5;
}

int main()
{
  foo();
}
