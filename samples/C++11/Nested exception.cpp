#include <iostream>
#include <exception>
#include <string>

void foo() 
{
  try 
  { 
    throw 42;
  }
  catch(...)
  { 
    std::throw_with_nested(std::logic_error("bar"));
  }
}

int main()
{
  try
  {
    foo();
  }
  catch(std::logic_error &e)
  {
    std::rethrow_if_nested(e);
  }
}
