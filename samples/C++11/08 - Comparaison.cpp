#include <iostream>
#include <vector>
#include <algorithm>

using std::begin;
using std::end;

static bool is_odd(int i)
{
  return (i%2)==1;
}

int main()
{
  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::cout << std::boolalpha << std::all_of(begin(foo), end(foo), is_odd) << '\n';
  }

  {
    std::vector<int> foo{1, 5, 9};
    std::cout << std::boolalpha << std::all_of(begin(foo), end(foo), is_odd) << '\n';
  }

  {
    std::vector<int> foo{4, 12};
    std::cout << std::boolalpha << std::all_of(begin(foo), end(foo), is_odd) << '\n';
  }



  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::cout << std::boolalpha << std::any_of(begin(foo), end(foo), is_odd) << '\n';
  }

  {
    std::vector<int> foo{1, 5, 9};
    std::cout << std::boolalpha << std::any_of(begin(foo), end(foo), is_odd) << '\n';
  }

  {
    std::vector<int> foo{4, 12};
    std::cout << std::boolalpha << std::any_of(begin(foo), end(foo), is_odd) << '\n';
  }



  {
    std::vector<int> foo{1, 4, 5, 9, 12};
    std::cout << std::boolalpha << std::none_of(begin(foo), end(foo), is_odd) << '\n';
  }

  {
    std::vector<int> foo{1, 5, 9};
    std::cout << std::boolalpha << std::none_of(begin(foo), end(foo), is_odd) << '\n';
  }

  {
    std::vector<int> foo{4, 12};
    std::cout << std::boolalpha << std::none_of(begin(foo), end(foo), is_odd) << '\n';
  }
}
