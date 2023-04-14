#include <iostream>
#include <vector>
#include <algorithm>

static int gen()
{
  static int i = 0;
  i += 5;
  return i;
}

int main()
{
  {
    std::vector<int> foo(4);
    std::fill(foo.begin(), foo.end(), 42);
    std::cout << foo[0] << ' ' << foo[1] << ' ' << foo[2] << ' ' << foo[3] << '\n';
  }

  {
    std::vector<int> foo;
    std::fill_n(std::back_inserter(foo), 4, 43);
    std::cout << foo[0] << ' ' << foo[1] << ' ' << foo[2] << ' ' << foo[3] << '\n';
  }

  {
    std::vector<int> foo(4, 44);
    std::cout << foo[0] << ' ' << foo[1] << ' ' << foo[2] << ' ' << foo[3] << '\n';
  }

  {
    std::vector<int> foo(4);
    std::generate(foo.begin(), foo.end(), gen);  // 5 10 15 20
    std::cout << foo[0] << ' ' << foo[1] << ' ' << foo[2] << ' ' << foo[3] << '\n';
  }

}
