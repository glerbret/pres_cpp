#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
  std::vector<int> foo{10,20,30,5,15};

  std::make_heap(foo.begin(), foo.end());
  std::cout << foo.front() << '\n';

  std::pop_heap(foo.begin(), foo.end());
  foo.pop_back();
  std::cout << foo.front() << '\n';

  foo.push_back(99);
  std::push_heap(foo.begin(), foo.end());
  std::cout << foo.front() << '\n';

  std::sort_heap(foo.begin(), foo.end());
  for(size_t i = 0; i < foo.size(); ++i)
  {
    std::cout << foo[i] << ' ';
  }
  std::cout << '\n';
}
