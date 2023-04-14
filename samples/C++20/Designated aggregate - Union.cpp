#include <iostream>

union U
{
  int a;
  const char* b;
};

int main()
{
  {
    U u = { .b = "foo" };
    std::cout << u.b << "\n";
  }

#if 0
  {
    U u = { .a = 1, .b = "asdf" };  // Erreur : un seul membre sur les unions
  }
#endif
}
