#include <iostream>
#include <vector>

int main()
{
  std::vector<int> v{1, 2, 5};
 
  for(using T = int; T e : v)
  {
    std::cout << e << "\n";
  }
}
