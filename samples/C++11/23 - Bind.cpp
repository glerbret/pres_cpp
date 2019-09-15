#include <iostream>
#include <functional>

static int foo(int a, int b)
{
  return (a - 1) * b;
}

int main()
{
  std::function<int(int)> bar = std::bind(&foo, std::placeholders::_1, 2);
  std::cout << bar(3) << '\n';

  auto baz = std::bind(&foo, std::placeholders::_2, std::placeholders::_1);
  std::cout << baz(3, 2, 1, 2, 3) << '\n';
}
