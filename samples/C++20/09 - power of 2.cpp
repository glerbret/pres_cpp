#include <iostream>
#include <bit>

int main()
{
  std::cout << std::ispow2(4u) << "\n";
  std::cout << std::ispow2(7u) << "\n";
  std::cout << std::ceil2(7u)  << "\n";
  std::cout << std::ceil2(8u)  << "\n";
  std::cout << std::floor2(7u) << "\n";

  std::cout << std::rotl(6u, 2) << "\n";
  std::cout << std::rotr(6u, 1) << "\n";
  std::cout << std::popcount(6u) << "\n";
}
