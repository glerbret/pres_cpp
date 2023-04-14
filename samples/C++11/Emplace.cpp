#include <iostream>
#include <vector>

class Point 
{
public:
  Point(int a, int b)
    : m_a(a)
    , m_b(b)
  {
  }

  int m_a;
  int m_b;
};

int main()
{
  std::vector<Point> foo;
  foo.emplace_back(2, 5);

  std::cout << foo[0].m_a << " " << foo[0].m_b << "\n";
}
