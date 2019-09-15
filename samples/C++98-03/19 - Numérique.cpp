#include <iostream>
#include <vector>
#include <numeric>

int main()
{
  {
    std::vector<int> foo{18, 5, 6, 8};
    std::cout << std::accumulate(foo.begin(), foo.end(), 1, std::multiplies<int>()) << '\n';
  }

  {
    std::vector<int> foo{18, 5, 6, 8};
    std::vector<int> bar;

    std::adjacent_difference(foo.begin(), foo.end(), back_inserter(bar), std::minus<int>());
    for(size_t i = 0; i < bar.size(); ++i)
    {
      std::cout << bar[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{1, 2, 3, 4};
    std::vector<int> bar{2, 3, 4, 5};

    std::cout << std::inner_product(foo.begin(), foo.end(), bar.begin(), 0) << '\n';
  }

  {
    std::vector<int> foo{1, 2, 3, 4};
    std::vector<int> bar;

    std::partial_sum(foo.begin(), foo.end(), back_inserter(bar));
    for(size_t i = 0; i < bar.size(); ++i)
    {
      std::cout << bar[i] << ' ';
    }
    std::cout << '\n';
  }

#if 0
  // Factorielle
  {
    std::vector<int> foo{1, 2, 3, 4};
    std::vector<int> bar;

    std::partial_sum(foo.begin(), foo.end(), back_inserter(bar), std::multiplies<int>());
    for(size_t i = 0; i < bar.size(); ++i)
    {
      std::cout << bar[i] << ' ';
    }
    std::cout << '\n';
  }
#endif
}
