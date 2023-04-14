#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  {
    std::vector<int> foo{1, 5, 6, 8};
    std::vector<int> bar{2, 5};
    std::vector<int> baz;

    std::merge(foo.begin(), foo.end(), bar.begin(), bar.end(), std::back_inserter(baz));
    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << baz[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{1, 5, 6, 8, 2, 5};

    std::inplace_merge(foo.begin(), foo.begin() + 4, foo.end());
    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }
}
