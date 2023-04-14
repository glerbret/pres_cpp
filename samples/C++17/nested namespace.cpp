#include <iostream>

namespace A::B::C
{
  int foo = 5;
}

int main()
{
  std::cout << A::B::C::foo << "\n";
}
