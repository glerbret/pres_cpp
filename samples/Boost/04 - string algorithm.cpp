#include <iostream>
#include <string>
#include <vector>
#include <boost/algorithm/string.hpp>
#include <boost/algorithm/string/trim_all.hpp>

int main()
{
  {
    std::string foo{"Boost"};
    std::cout << boost::algorithm::to_upper_copy(foo) << '\n';
  }

  {
    std::string foo{"Boost"};
//    std::cout << boost::algorithm::erase_all_copy(foo, "o") << '\n';
  }

  {
    std::vector<std::string> foo{"foo1", "foo2", "foo3"};
    std::cout << boost::algorithm::join(foo, "-");
  }

  {
    std::string foo = "Boost C++ Libraries";
    std::vector<std::string> bar;
    boost::algorithm::split(bar, foo, boost::algorithm::is_space());
    for(auto it : bar)
    {
      std::cout << it << ' ';
    }
    std::cout << '\n';
  }

  {
    std::string foo{"Boost"};
    std::cout << boost::algorithm::replace_all_copy(foo, "o", "0") << '\n';
  }

  {
    std::string foo{"    Boost    "};
    std::cout << boost::algorithm::trim_left_copy(foo) << '\n';
    std::cout << boost::algorithm::trim_right_copy(foo) << '\n';
    std::cout << boost::algorithm::trim_copy(foo) << '\n';
  }

  {
    std::string foo{"    Boost    Lib    "};
    std::cout << boost::algorithm::trim_all_copy(foo) << '\n';
  }
}
