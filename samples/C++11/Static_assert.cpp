#include <iostream>

int main()
{
  static_assert(sizeof(int) == 3, "Taille incorrecte");
}