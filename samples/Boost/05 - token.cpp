#include <iostream>
#include <string>
#include <vector>
#include <boost/tokenizer.hpp>

int main()
{
  std::string data = "un|deux|trois";
  boost::char_separator<char> sep("|");
  boost::tokenizer<boost::char_separator<char>> tokens(data, sep);

  for(auto it : tokens)
  {
    std::cout << it << '\n';
  }
}
