#include <iostream>
#include <vector>
#include <numeric>

int main()
{
  int foo[] = {1, 2, 3, 4};
  std::vector<int> bar{2, 3, 4, 5};

  std::cout << std::accumulate(std::begin(foo), std::end(foo), 0) << "\n";
  std::cout << std::accumulate(std::begin(bar), std::end(bar), 0) << "\n";
}
