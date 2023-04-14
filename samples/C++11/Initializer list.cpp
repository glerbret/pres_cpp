#include <iostream>
#include <vector>
#include <initializer_list>

struct Foo
{
  Foo(std::initializer_list<int> l) : m_vec(l)
  {
    std::cout << l.size() << '\n';
  }

  void append(std::initializer_list<int> l)
  {
    for(std::initializer_list<int>::iterator it = l.begin(); it != l.end(); ++it)
    {
      m_vec.push_back(*it);
    }
  }

  std::vector<int> m_vec;
};

int main()
{
  Foo foo = {1, 2, 3, 4, 5};
  for(size_t i = 0; i < foo.m_vec.size(); ++i)
  {
    std::cout << foo.m_vec[i] << ' ';
  }
  std::cout << '\n';

  foo.append({6, 7, 8});
  for(size_t i = 0; i < foo.m_vec.size(); ++i)
  {
    std::cout << foo.m_vec[i] << ' ';
  }
  std::cout << '\n';
}
