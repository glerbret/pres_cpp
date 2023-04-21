#include <iostream>
#include <functional>

int main()
{
  int a{10};

  std::reference_wrapper<int> aref = std::ref(a);
  aref++;   // a : 11
  std::cout << a << "\n";
}
