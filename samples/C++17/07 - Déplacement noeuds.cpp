#include <iostream>
#include <map>
#include <string>

int main()
{
  std::map<int, std::string> foo {{1,"foo1"}, {2,"foo2"}};
  std::map<int, std::string> bar {{2,"bar2"}};
  for(const auto& [k,v] : foo)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
  for(const auto& [k,v] : bar)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
  std::cout << '\n';

  bar.insert(foo.extract(1));
  for(const auto& [k,v] : foo)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
  for(const auto& [k,v] : bar)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
  std::cout << '\n';

  auto r = bar.insert(foo.extract(2));
  for(const auto& [k,v] : foo)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
  for(const auto& [k,v] : bar)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
  std::cout << std::boolalpha << r.inserted << ' ' << r.node.key() << ' ' << r.node.mapped() << '\n';
  std::cout << '\n';

  r.node.key() = 3;
  bar.insert(r.position, std::move(r.node));
  for(const auto& [k,v] : foo)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
  for(const auto& [k,v] : bar)
  {
    std::cout << k << '-' << v << ' ';
  }
  std::cout << '\n';
}
