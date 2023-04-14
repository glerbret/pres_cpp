#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <algorithm>

int main()
{
  std::vector<unsigned char> foo{0x10, 0x20, 0x30};
  std::vector<unsigned char> bar{0xFF, 0x25, 0x00};

  {
    std::vector<unsigned char> baz;
    std::transform(std::begin(foo), std::end(foo), std::begin(bar), std::back_inserter(baz), std::bit_and<unsigned char>());

    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << std::hex << std::setfill('0') << std::setw(2) << static_cast<unsigned int>(baz[i]) << " ";
    }
    std::cout << '\n';
  }

  {
    std::vector<unsigned char> baz;
    std::transform(std::begin(foo), std::end(foo), std::begin(bar), std::back_inserter(baz), std::bit_or<unsigned char>());

    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << std::hex << std::setfill('0') << std::setw(2) << static_cast<unsigned int>(baz[i]) << " ";
    }
    std::cout << '\n';
  }

  {
    std::vector<unsigned char> baz;
    std::transform(std::begin(foo), std::end(foo), std::begin(bar), std::back_inserter(baz), std::bit_xor<unsigned char>());

    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << std::hex << std::setfill('0') << std::setw(2) << static_cast<unsigned int>(baz[i]) << " ";
    }
    std::cout << '\n';
  }
}
