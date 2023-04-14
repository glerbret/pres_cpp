#include <iostream>
#include <map>
#include <string>

int main()
{
  {
    std::map<int, std::string> foo {{1,"foo1"}, {2,"foo2"}};
    std::map<int, std::string> bar {{3,"bar2"}};

    foo.merge(bar);
    for(const auto& [k,v] : foo)
    {
      std::cout << k << '-' << v << ' ';
    }
    std::cout << '\n';
    std::cout << '\n';
  }

  {
    std::map<int, std::string> foo {{1,"foo1"}, {2,"foo2"}};

    foo.insert_or_assign(3, "foo3");
    for(const auto& [k,v] : foo)
    {
      std::cout << k << '-' << v << ' ';
    }
    std::cout << '\n';

    foo.insert_or_assign(2, "foo2bis");
    for(const auto& [k,v] : foo)
    {
      std::cout << k << '-' << v << ' ';
    }
    std::cout << '\n';
  }
}
