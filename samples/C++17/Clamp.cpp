#include <iostream>
#include <algorithm>

int main()
{
  std::cout << std::clamp(1, 18, 42) << "\n";
  std::cout << std::clamp(54, 18, 42) << "\n";
  std::cout << std::clamp(25, 18, 42) << "\n";
}
