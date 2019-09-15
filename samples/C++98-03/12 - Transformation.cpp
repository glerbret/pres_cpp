#include <iostream>
#include <vector>
#include <algorithm>

static int doubleValue(int i)
{
  return 2 * i;
}

int main()
{
  {
    std::vector<int> foo{4, 5, 7, 9};
    std::vector<int> bar(4);

    std::transform(foo.begin(), foo.end(), bar.begin(), doubleValue);
    for(size_t i = 0; i < bar.size(); ++i)
    {
      std::cout << bar[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{4, 5, 7, 9};
    std::vector<int> bar{2, 3, 6, 1};
    std::vector<int> baz(4);

    std::transform(foo.begin(), foo.end(), bar.begin(), baz.begin(), std::plus<int>());
    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << baz[i] << ' ';
    }
    std::cout << '\n';
  }
}
