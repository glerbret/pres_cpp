#include <iostream>

int main()
{
  std::cout << R"(Message\n en une seule \n ligne)" << '\n';
  std::cout << R"--(Message\n en une seule \n ligne)--" << '\n';
  std::cout << u8R"(Message\n en une seule \n ligne)" << '\n';
}
