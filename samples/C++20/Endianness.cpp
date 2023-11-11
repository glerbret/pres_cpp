#include <bit>
#include <iostream>
 
int main()
{
  if(std::endian::native == std::endian::big)
    std::cout << "big-endian\n";
  else if(std::endian::native == std::endian::little)
    std::cout << "little-endian\n";
  else
    std::cout << "mixed-endian\n";
}
