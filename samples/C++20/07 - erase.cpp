#include <vector>
#include <map>
#include <string>
#include <iostream>

int main()
{
  std::vector<int> foo {5, 12, 2, 56, 18, 33};
  std::erase_if(foo, [](int i) {return i > 20;});

  for(int i : foo)
  {
    std::cout << i << " ";
  }
  std::cout << "\n";

  std::map<int, std::string> bar{{5, "a"}, {12, "b"}, {2, "c"}, {42, "d"}};
  std::erase_if(bar, [](std::pair<int, std::string> i) {return i.first > 20;});

  for(auto i : bar)
  {
    std::cout << i.first << " : " << i.second << " ";
  }
  std::cout << "\n";
}
