#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <random>

using std::begin;
using std::end;

int main()
{
  std::vector<int> foo{4, 5, 9, 12};
  unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();

  std::shuffle(begin(foo), end(foo), std::default_random_engine(seed));
  for(size_t i = 0; i < foo.size(); ++i)
  {
    std::cout << foo[i] << ' ';
  }
  std::cout << '\n';
}
