#include <iostream>
#include <cstdint>
#include <bit>

int main()
{
  uint16_t i = 0xCAFE;
  std::cout << std::hex << std::byteswap(i) << "\n";

  uint32_t j = 0xDEADBEEFu;
  std::cout << std::hex << std::byteswap(j) << "\n";
}
