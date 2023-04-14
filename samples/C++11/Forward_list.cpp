#include <iostream>
#include <forward_list>
#include <numeric>

int main()
{
  {
    std::forward_list<int> foo{2, 5, 9, 8, 2, 6, 8, 9, 12};
    std::cout << std::accumulate(foo.begin(), foo.end(), 0) << '\n';
  }
}
