#include <iostream>
#include <tuple>

int main()
{
  std::tuple<int, long, long> foo{42, 58L, 9L};

  std::cout << std::get<int>(foo) << '\n';
#if 0
  std::cout << std::get<long>(foo) << '\n';
#endif
}
