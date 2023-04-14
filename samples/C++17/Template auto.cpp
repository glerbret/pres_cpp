#include <iostream>

template <auto value> constexpr auto FOO = value;

int main()
{
  constexpr auto const foo = FOO<100>;
  std::cout << foo << "\n";
}
