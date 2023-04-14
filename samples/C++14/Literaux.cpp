#include <iostream>

int main()
{
  {
    int foo = 0b101010;

    std::cout << foo << '\n';
  }

  {
    std::cout << 0b0010'1010 << '\n';
    std::cout << 1'000 << '\n';
    std::cout << 010'00 << '\n';
  }
}
