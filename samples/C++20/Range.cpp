#include <ranges>
#include <algorithm>
#include <vector>
#include <iostream>

int main()
{
  for(int i : std::views::iota(1, 10))
  {
    std::cout << i << ' ';
  }
  std::cout << "\n";

  std::vector<int> foo{0, 1, 2, 3, 4, 5};
  auto even = [](int i){ return (i % 2) == 0; };
  auto square = [](int i) { return i * i; };

  for(int i : foo | std::views::filter(even) |  std::views::transform(square))
  {
    std::cout << i << ' ';
  }
  std::cout << "\n";
}
