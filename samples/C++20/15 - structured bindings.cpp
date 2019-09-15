#include <iostream>
#include <tuple>

int main()
{
  std::tuple foo{5, 42};

  auto[a, b] = foo;
  auto f1 = [a] { return a; };
  auto f2 = [=] { return b; };

  std::cout << f1() << "\n";
  std::cout << f2() << "\n";
}
