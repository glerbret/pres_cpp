#include <iostream>

static constexpr int foo()
{
  return 42;
}

int main()
{
  char bar[foo()] = "azerty";

  int a = 42;
  switch(a)
  {
    case foo():
      std::cout << bar << '\n';
      break;

    default:
      break;
  }
}
