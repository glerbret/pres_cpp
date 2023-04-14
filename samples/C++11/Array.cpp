#include <iostream>
#include <array>
#include <numeric>

int main()
{
  {
    std::array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9};
    std::cout << std::accumulate(foo.begin(), foo.end(), 0) << '\n';
  }

#if 0
  {
    std::array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9, 17};
  }
#endif
}
