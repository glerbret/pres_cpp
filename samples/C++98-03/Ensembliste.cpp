#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  {
    std::vector<int> foo{1, 5, 6, 8};
    std::vector<int> bar{2, 5};
    std::vector<int> baz{1, 6};

    std::cout << std::boolalpha << std::includes(foo.begin(), foo.end(), bar.begin(), bar.end()) << '\n';
    std::cout << std::boolalpha << std::includes(foo.begin(), foo.end(), baz.begin(), baz.end()) << '\n';
  }

  {
    std::vector<int> foo{1, 5, 6, 8};
    std::vector<int> bar{2, 5};
    std::vector<int> baz;

    std::set_union(foo.begin(), foo.end(), bar.begin(), bar.end(), back_inserter(baz));
    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << baz[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{1, 5, 6, 8};
    std::vector<int> bar{2, 5};
    std::vector<int> baz;

    std::set_intersection(foo.begin(), foo.end(), bar.begin(), bar.end(), back_inserter(baz));
    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << baz[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{1, 5, 6, 8};
    std::vector<int> bar{2, 5};
    std::vector<int> baz;

    std::set_difference(foo.begin(), foo.end(), bar.begin(), bar.end(), back_inserter(baz));
    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << baz[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> foo{1, 5, 6, 8};
    std::vector<int> bar{2, 5};
    std::vector<int> baz;

    std::set_symmetric_difference(foo.begin(), foo.end(), bar.begin(), bar.end(), back_inserter(baz));
    for(size_t i = 0; i < baz.size(); ++i)
    {
      std::cout << baz[i] << ' ';
    }
    std::cout << '\n';
  }
}
