#include <iostream>
 
//#define FOO
//#define BAR

int main()
{
#ifdef FOO
  std::cout << "FOO\n";
#elifdef BAR
  std::cout << "BAR\n";
#else
  std::cout << "Autre\n";
#endif
}
