#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{2, 5, 2, 1, 8, 8, 6, 2, 8, 8, 8, 2};

  std::vector<int>::iterator it = find(foo.begin(), foo.end(), 6);
  std::cout << *it << ' ' << *(it+1) << '\n';

  std::vector<int>::iterator it2 = std::adjacent_find(foo.begin(), foo.end());
  std::cout << *it2 << ' ' << *(it2 - 1) << ' ' << *(it2 + 2) << '\n';

  std::vector<int>::iterator it3 = std::search_n(foo.begin(), foo.end(), 3, 8);
  std::cout << *it3 << ' ' << *(it3 - 1) << ' ' << *(it3 + 2) << '\n';
}
