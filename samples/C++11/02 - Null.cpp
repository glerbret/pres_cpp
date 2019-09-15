#include <iostream>

static void foo(char*)
{
  std::cout << "chaine\n";
}

static void foo(int)
{
  std::cout << "entier\n";
}

int main()
{
  foo(0);
#if 1
  foo(NULL);
#else
  foo(nullptr);
#endif
}
