#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{1, 5, 8, 2};

  {
    std::vector<int> bar{1, 5, 8, 2};
    std::cout << std::boolalpha << std::equal(foo.begin(), foo.end(), bar.begin()) << '\n';
    std::cout << std::boolalpha << (foo == bar) << '\n';
  }

  {
    std::vector<int> bar{1, 3, 2, 7};
    std::cout << std::boolalpha << std::equal(foo.begin(), foo.end(), bar.begin()) << '\n';
    std::cout << std::boolalpha << (foo == bar) << '\n';
  }

  {
    std::vector<int> bar{1, 5, 8, 2, 4};
    std::cout << std::boolalpha << std::equal(foo.begin(), foo.end(), bar.begin()) << '\n';
    std::cout << std::boolalpha << (foo == bar) << '\n';
  }

  {
    std::vector<int> bar{1, 3, 2, 7};
    std::pair<std::vector<int>::iterator, std::vector<int>::iterator> res = std::mismatch(foo.begin(), foo.end(), bar.begin());
    std::cout << *(res.first) << ' ' << *(res.second) << '\n';
  }
}
