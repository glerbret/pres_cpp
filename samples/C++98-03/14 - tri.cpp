#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  {
    std::vector<int> foo{4, 13, 28, 9 , 54};

    std::sort(foo.begin(), foo.end());
    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

    std::partial_sort(foo.begin(), foo.begin() + 3, foo.end());    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }
}
