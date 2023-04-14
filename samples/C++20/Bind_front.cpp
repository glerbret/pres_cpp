#include <functional>
#include <iostream>

int foo(int a, int b, int c, int d)
{
  return a * b * c + d;
}

int main()
{
  std::cout << foo(2, 3, 4, 5) << "\n";

  auto bar = std::bind(&foo, 2, 3, 4, std::placeholders::_1);
  std::cout << bar(6) << "\n";

  auto baz = std::bind_front(&foo, 2, 3, 4);
  std::cout << baz(7) << "\n";
}
