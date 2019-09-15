#include <iostream>

struct Foo
{
  int a;
  int b = 42;
};

int main()
{
  {
    Foo foo{6};

    std::cout << foo.a << ' ' << foo.b << '\n';
  }

  {
    Foo foo{6, 5};

    std::cout << foo.a << ' ' << foo.b << '\n';
  }
}
