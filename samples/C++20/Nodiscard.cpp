#include <iostream>

[[ nodiscard("Must be checked") ]] static int foo()
{
  return 5;
}

struct Bar {
  [[ nodiscard ]]Bar() {}
};

int main()
{
#if 0
  Bar b{};
#else
  Bar{};
#endif
  foo();
}
