#include <iostream>

int main()
{
  int foo = 1;

  switch(foo)
  {
    case 1:
    case 2:
      std::cout << "Cas 1-2\n";
#if 1
      [[ fallthrough ]];
#endif

    case 3:
      std::cout << "Cas 3\n";

    case 4:
      std::cout << "Cas 4\n";
      break;

    default:
      std::cout << "Cas default\n";
      break;
  }
}
