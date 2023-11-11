#include <iostream>
#include <bit>

int main()
{
  std::cout << std::has_single_bit(4u) << "\n";
  std::cout << std::has_single_bit(7u) << "\n";
  std::cout << std::bit_ceil(7u)  << "\n";
  std::cout << std::bit_ceil(8u)  << "\n";
  std::cout << std::bit_floor(7u) << "\n";
  std::cout << std::bit_width(7u) << "\n";

  std::cout << std::rotl(6u, 2) << "\n";
  std::cout << std::rotr(6u, 1) << "\n";
  std::cout << std::popcount(6u) << "\n";
}
