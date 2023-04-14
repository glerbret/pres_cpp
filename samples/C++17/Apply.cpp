#include <iostream>
#include <tuple>
#include <array>
#include <string>

using namespace std::literals;

static void foo(int a, long b, std::string c)
{
  std::cout << a << ' ' << b << ' ' << c << '\n';
}

static void bar(int a, int b, int c)
{
  std::cout << a << ' ' << b << ' ' << c << '\n';
}

int main()
{
  {
    std::tuple baz{42, 5L, "bar"s};
    std::apply(foo, baz);
  }

  {
    std::array<int, 3> baz{42, 5, 12};
    std::apply(bar, baz);
  }
}
