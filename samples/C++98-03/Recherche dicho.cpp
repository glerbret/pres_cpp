#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{4, 5, 7, 9, 12};

  {
    std::vector<int>::iterator it = std::lower_bound(foo.begin(), foo.end(), 6);
    std::cout << *it << '\n';
  }

  {
    std::vector<int>::iterator it = std::lower_bound(foo.begin(), foo.end(), 9);
    std::cout << *it << '\n';
  }

  {
    std::vector<int>::iterator it = std::upper_bound(foo.begin(), foo.end(), 9);
    std::cout << *it << '\n';
  }

  {
    std::pair<std::vector<int>::iterator, std::vector<int>::iterator> res = std::equal_range(foo.begin(), foo.end(), 6);
    std::cout << *(res.first) << ' ' << *(res.second) << '\n';
  }
}
