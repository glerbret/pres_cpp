#include <iostream>

struct S
{
  int a;
  int b;
  int c{0};
};

int main()
{
  {
    S s{.a = 1, .b = 2};
    std::cout << s.a << " " << s.b << " " << s.c << "\n";
  }

  {
    S s{.a = 1, .b = 2, .c = 3};
    std::cout << s.a << " " << s.b << " " << s.c << "\n";
  }

#if 0
  {
    S s{.b = 2, .a = 1};   // Erreur sur l'ordre
  }
#endif
}