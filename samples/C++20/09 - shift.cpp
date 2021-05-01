#include <vector>
#include <algorithm>
#include <iostream>

int main()
{
  std::vector<int> foo{5, 10, 15, 20};
  std::shift_left(foo.begin(), foo.end(), 2);
  // {15, 20, ?, ,}
  for(int i : foo)
  {
      std::cout << i << " ";
  }
  std::cout << "\n";

  std::vector<int> bar{5, 10, 15, 20};
  std::shift_right(bar.begin(), bar.end(), 1);
  // {?, 5, 10, 15}
  for(int i : bar)
  {
      std::cout << i << " ";
  }
  std::cout << "\n";
}
