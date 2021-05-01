#include <array>
#include <span>
#include <iostream>

int main()
{
  std::array<int, 5> foo = {7, 12, 28, 3, 9};
  std::span<int> bar(foo.data(), 3);

  std::cout << bar.size() << "\n";
  std::cout << bar.front() << "\n"; 
  std::cout << bar[2] << "\n"; 

  std::span<int> baz = bar.first(2);
  for(const auto i : baz)
  {
    std::cout << i << " ";
  }
  std::cout << "\n";
}
