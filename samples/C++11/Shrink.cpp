#include <iostream>
#include <vector>

int main()
{
  std::vector<int> foo{12, 25};
  foo.reserve(15);
  std::cout << foo.size() << " / " << foo.capacity() << '\n';

  foo.shrink_to_fit();
  std::cout << foo.size() << " / " << foo.capacity() << '\n';
}
