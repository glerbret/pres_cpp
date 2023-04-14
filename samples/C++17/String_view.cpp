#include <iostream>
#include <string>
#include <string_view>

int main()
{
  {
    std::string foo = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus.";

    std::string_view bar(&foo[0], 11);
    std::cout << bar.size() << " - " << bar << '\n';

    foo[0] = 'l';
    std::cout << bar.size() << " - " << bar << '\n';
    std::cout << bar[0] << '\n';

    bar.remove_suffix(6);
    std::cout << bar.size() << " - " << bar << '\n';
  }

  {
    char foo[3] = {'B', 'a', 'r'};
    std::string_view bar(foo, sizeof foo);
    std::cout << bar.size() << " - " << bar << '\n';
  }
}
