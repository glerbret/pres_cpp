#include <iostream>

template<typename T>
constexpr T PI = T(3.1415926535897932385);

template<>
constexpr const char* PI<const char*> = "pi";

int main()
{
  std::cout << PI<int> << '\n';
  std::cout << PI<double> << '\n';
  std::cout << PI<const char*> << '\n';
}
