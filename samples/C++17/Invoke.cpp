#include <iostream>
#include <functional>

static int foo(int i)
{
  return i + 42;
}

struct Bar
{
  int baz(int i)
  {
    return i + 42;
  }
};

int main()
{
  std::cout << std::invoke(&foo, 8) << '\n';

  Bar bar;
  std::cout << std::invoke(&Bar::baz, bar, 8) << '\n';
}
