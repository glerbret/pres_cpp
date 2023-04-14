#include <iostream>
#include <string>
#include <algorithm>
#include <cstring>

int main()
{
  std::string foo = "Hello ";
  std::string bar = "world!";

  foo.resize_and_overwrite(20, 
                          [sz = foo.size(), bar] (char* buf, size_t buf_size) 
                          {
                            auto to_copy = std::min(buf_size - sz, bar.size());
                            memcpy(buf + sz, bar.data(), to_copy);
                            return sz + to_copy; });

  std::cout << foo  << "\n";
}
