#include <iostream>
#include <vector>

int main()
{
  std::vector<int> foo{1, 8, 5, 56, 42};
  for(size_t i = 0; const auto& bar : foo) 
  {
    std::cout << bar << " " << i << "\n";
    ++i; 
  }
}
