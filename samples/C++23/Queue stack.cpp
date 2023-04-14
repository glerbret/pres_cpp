#include <iostream>
#include <vector>
#include <queue>
#include <stack>

int main()
{
  std::vector<int> v{1, 3, 7, 13};

  std::queue q(std::begin(v), std::end(v));
  std::stack s(std::begin(v), std::end(v));

  std::cout << q.front() << "\n";
  std::cout << s.top() << "\n";
}
