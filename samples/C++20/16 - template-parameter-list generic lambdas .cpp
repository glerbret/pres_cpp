#include <iostream>
#include <vector>

int main()
{
  auto foo = []<typename T>(T first, T second) { return first + second; };

  std::cout << foo(1, 5) << "\n";
#if 0
  std::cout << foo(1., 5) << "\n";
#endif

  auto bar = []<typename T>(std::vector<T> vec) { return std::size(vec); };

  std::cout << bar(std::vector<int>{1, 2, 3}) << "\n";
  std::cout << bar(std::vector<double>{1., 2.}) << "\n";
#if 0
  std::cout << bar(5) << "\n";
#endif
}
