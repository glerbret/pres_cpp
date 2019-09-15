#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  {
    std::vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

    std::random_shuffle(foo.begin(), foo.end());
    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << foo[i] << ' ';
    }
    std::cout << '\n';
  }
}
