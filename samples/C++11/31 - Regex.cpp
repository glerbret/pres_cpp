#include <iostream>
#include <string>
#include <regex>


int main()
{
  {
    std::string s("abcd123efg");
    std::regex r("[0-9]+");
    std::smatch m;

    std::regex_search(s, m, r);
    std::cout << m.size() << '\n';
    std::cout << m.str(0) << '\n';
    std::cout << m.position(0) << '\n';
    std::cout << m.prefix() << '\n';
    std::cout << m.suffix() << '\n';
  }

  {
    std::string s("abcd123efg");
    std::regex r("[0-9]+");

    std::cout << std::regex_replace(s, r, "-") << '\n';
  }
}
