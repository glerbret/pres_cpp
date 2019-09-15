#include <iostream>
#include <vector>
#include <algorithm>

using std::begin;
using std::end;

static bool isOdd(int i)
{
  return (i%2)==1;
}

int main()
{
  {
    std::vector<int> foo{4, 5, 9, 12};

    std::cout << std::boolalpha << std::is_partitioned(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{9, 5, 4, 12};

    std::cout << std::boolalpha << std::is_partitioned(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{9, 5, 4, 12};

    std::cout << *std::partition_point(begin(foo), end(foo), isOdd) << '\n';
  }
}
