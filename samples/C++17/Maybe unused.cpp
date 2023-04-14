#include <iostream>

#if 0
[[ maybe_unused ]] static int foo([[ maybe_unused ]]int a,
                                  [[ maybe_unused ]] int b)
#else
static int foo(int a,
               int b)
#endif
{
  return 0;
}

int main()
{
}
