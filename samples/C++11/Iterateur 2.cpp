#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

typedef std::vector<std::string>::iterator Iter;

int main()
{
  {
    std::vector<int> foo{5, 3, 8, 12};

    auto it = std::begin(foo);
    std::cout << *it << " " << *next(it) << "\n";
  }

  {
    std::vector<std::string> foo(3);
    std::vector<std::string> bar{"one","two","three"};
    std::copy(std::move_iterator<Iter>(bar.begin()), std::move_iterator<Iter>(bar.end()), foo.begin());

    for(size_t i = 0; i < foo.size(); ++i)
    {
      std::cout << "'" << foo[i] << "' ";
    }
    std::cout << '\n';
    for(size_t i = 0; i < bar.size(); ++i)
    {
      std::cout << "'" << bar[i] << "' ";
    }
    std::cout << '\n';
  }
}
