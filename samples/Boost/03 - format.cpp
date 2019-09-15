#include <iostream>
#include <boost/format.hpp>

int main()
{
  std::cout << boost::format{"%2%/%1%/%3%"} % 12 % 5 % 2014 << '\n';
  std::cout << boost::format{"%|| %|| %||"} % 12 % 5 % 2014 << '\n';

  std::cout << boost::format{"%|1$+|"} % 12 << '\n';
  std::cout << boost::format{"%|1$#x|"} % 12 << '\n';

  std::cout << boost::format{"%1% %2% %1%"} % boost::io::group(std::showpos, 1) % 2 << '\n';
}
