#include <iostream>
#include <functional>

static int foo(int i)
{
  return i + 42;
}

struct Foo
{
  int bar(int i)
  {
    return i + 42;
  }
};

int main()
{
  {
    std::cout << std::invoke(&foo, 8) << '\n';
  }

  {
    Foo foo;
    std::cout << std::invoke(&Foo::bar, foo, 8) << '\n';
  }
}
