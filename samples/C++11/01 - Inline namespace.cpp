#include <iostream>

namespace V1
{
  static void foo()
  {
    std::cout << "V1\n";
  }
}

inline namespace V2
{
  static void foo()
  {
    std::cout << "V2\n";
  }
}

int main()
{
  V1::foo();
  V2::foo();

  foo();
}
