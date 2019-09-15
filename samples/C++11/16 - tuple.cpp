#include <iostream>
#include <string>
#include <tuple>

int main()
{
  std::tuple<int, std::string, double> foo = std::make_tuple(42, "FOO", 25.2);

  int a;
  double b;

  std::tie(a, std::ignore, b) = foo;
  std::cout << a << ' ' << b << '\n';

  std::string c = std::get<1>(foo);
  std::cout << c << '\n';

  auto bar = std::make_tuple(12, 5UL);
  auto baz = std::tuple_cat(foo, bar);

  std::cout << std::tuple_size<decltype(baz)>::value << '\n';
}
