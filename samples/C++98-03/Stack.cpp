#include <iostream>
#include <vector>
#include <stack>

int main()
{
  std::stack<int, std::vector<int> > foo;
  for(int i=0; i<5; ++i)
  {
    foo.push(i);
  }

  while(!foo.empty())
  {
    std::cout << ' ' << foo.top();
    foo.pop();
  }
}
