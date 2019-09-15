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
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::cout << std::boolalpha << std::all_of(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{1, 5, 9};
    std::cout << std::boolalpha << std::all_of(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{4, 12};
    std::cout << std::boolalpha << std::all_of(begin(foo), end(foo), isOdd) << '\n';
  }



  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::cout << std::boolalpha << std::any_of(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{1, 5, 9};
    std::cout << std::boolalpha << std::any_of(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{4, 12};
    std::cout << std::boolalpha << std::any_of(begin(foo), end(foo), isOdd) << '\n';
  }



  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::cout << std::boolalpha << std::none_of(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{1, 5, 9};
    std::cout << std::boolalpha << std::none_of(begin(foo), end(foo), isOdd) << '\n';
  }

  {
    std::vector<int> foo{4, 12};
    std::cout << std::boolalpha << std::none_of(begin(foo), end(foo), isOdd) << '\n';
  }



  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::vector<int> bar{4, 1, 5, 12, 9};

    std::cout << std::boolalpha << std::is_permutation(begin(foo), end(foo), begin(bar)) << '\n';
  }

  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::vector<int> bar{4, 2, 5, 12, 9};

    std::cout << std::boolalpha << std::is_permutation(begin(foo), end(foo), begin(bar)) << '\n';
  }
}
