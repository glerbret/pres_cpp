#include <iostream>
#include <vector>
#include <algorithm>

using std::begin;
using std::end;

int main()
{
  {
    std::vector<int> foo{4, 5, 9, 12};

    std::cout << std::boolalpha << std::is_sorted(begin(foo), end(foo)) << '\n';
  }

  {
    std::vector<int> foo{9, 5, 4, 12};

    std::cout << std::boolalpha << std::is_sorted(begin(foo), end(foo)) << '\n';
  }

  {
    std::vector<int> foo{4, 5, 2, 12};

    std::cout << *std::is_sorted_until(begin(foo), end(foo)) << '\n';
  }
}
