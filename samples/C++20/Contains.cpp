#include <map>
#include <string>
#include <iostream>

int main()
{
  std::map<int, std::string> foo{{1, "foo"}, {42, "bar"}};

  std::cout << std::boolalpha;
  std::cout << foo.contains(42) << "\n";
  std::cout << foo.contains(38) << "\n";
}
