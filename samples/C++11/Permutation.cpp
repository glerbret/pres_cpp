#include <iostream>
#include <vector>
#include <algorithm>

using std::begin;
using std::end;

int main()
{
  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::vector<int> bar{5, 4, 12, 9, 1};

    std::cout << std::boolalpha << std::is_permutation(begin(foo), end(foo), begin(bar)) << '\n';
  }

  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::vector<int> bar{5, 4, 12, 7, 1};

    std::cout << std::boolalpha << std::is_permutation(begin(foo), end(foo), begin(bar)) << '\n';
  }
}
