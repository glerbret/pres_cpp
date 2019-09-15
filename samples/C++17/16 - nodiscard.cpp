#include <iostream>

[[ nodiscard ]] static int foo()
{
  return 5;
}

struct [[ nodiscard ]] Bar
{
};

static Bar baz()
{
  return Bar{};
}

int main()
{
  foo();
  baz();
}
