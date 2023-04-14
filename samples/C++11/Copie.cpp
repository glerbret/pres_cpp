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
  std::vector<int> foo{1, 4, 5, 9, 12};

  {
    std::vector<int> bar;
    std::copy_n(begin(foo), 4, std::back_inserter(bar));

    for(size_t i = 0; i < bar.size(); ++i)
    {
      std::cout << bar[i] << ' ';
    }
    std::cout << '\n';
  }

  {
    std::vector<int> bar;
    std::copy_if(begin(foo), end(foo), std::back_inserter(bar), is_odd);

    for(size_t i = 0; i < bar.size(); ++i)
    {
      std::cout << bar[i] << ' ';
    }
    std::cout << '\n';
  }
}
