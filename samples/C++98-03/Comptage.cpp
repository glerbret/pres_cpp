#include <iostream>
#include <vector>
#include <algorithm>

bool compare(int nb)
{
  return nb >= 5;
}

int main()
{
  std::vector<int> foo{2, 5, 2, 1, 8, 8, 6, 2, 8, 8, 8, 2};

  std::cout << std::count(foo.begin(), foo.end(), 8) << '\n';
  std::cout << std::count(foo.begin(), foo.end(), 7) << '\n';

  std::cout << std::count_if(foo.begin(), foo.end(), compare) << '\n';
}
