#include <iostream>

struct Foo
{
  int i;
};

struct Bar : Foo
{
  double l;
};

int main()
{
  Bar bar{{42}, 1.25};
  Bar baz{{}, 1.25};

  std::cout << bar.i << ' ' << bar.l << '\n';
  std::cout << baz.i << ' ' << baz.l << '\n';
}
