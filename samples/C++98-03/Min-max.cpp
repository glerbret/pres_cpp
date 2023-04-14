#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{18, 5, 6, 8};

  std::cout << *std::min_element(foo.begin(), foo.end()) << "\n";
  std::cout << *std::max_element(foo.begin(), foo.end()) << "\n";
}
