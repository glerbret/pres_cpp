#include <iostream>
#include <vector>
#include <algorithm>

using std::begin;
using std::end;

int main()
{
  {
    int bar = 4;
    auto foo = [&bar] (int a) -> int { bar *= a; return 3 * a;};

    std::cout << foo(5) << ' ' << bar << '\n';
  }

  {
    std::vector<int> foo{1, 8, 5, 6, 3, 7};
    std::vector<int> bar;

    std::copy_if(begin(foo), end(foo), std::back_inserter(bar), [] (int i) {return (i%2) == 1;});
    for(auto i : bar)
    {
      std::cout << i << ' ';
    }
    std::cout << '\n';
  }
}
