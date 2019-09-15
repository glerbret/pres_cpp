#include <iostream>
#include <cstddef>
#include <iomanip>

int main()
{
  std::byte b{5};
  std::cout << std::hex << std::setw(2) << std::setfill('0') << std::to_integer<unsigned int>(b) << '\n';

  b |= std::byte{2};
  std::cout << std::hex << std::setw(2) << std::setfill('0') << std::to_integer<unsigned int>(b) << '\n';

  b <<= 2;
  std::cout << std::hex << std::setw(2) << std::setfill('0') << std::to_integer<unsigned int>(b) << '\n';

#if 1
  b += std::byte{2};
#endif
}
