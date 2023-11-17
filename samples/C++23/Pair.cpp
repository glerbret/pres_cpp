#include <iostream>
#include <utility>
#include <vector>
#include <string>

int main()
{
  std::pair<std::string, std::vector<std::string>> foo("hello", {});
  std::cout << foo.first << " " << std::size(foo.second) << "\n";
}
