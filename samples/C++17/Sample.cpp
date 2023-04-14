#include <iostream>
#include <string>
#include <algorithm>
#include <random>
#include <ctime>

int main()
{
  std::string in = "abcdefgh";
  std::string out;
  std::mt19937 gen{static_cast<unsigned long>(time(nullptr))};
  std::sample(std::begin(in), std::end(in), std::back_inserter(out), 5, gen);

  for(auto it : out)
  {
    std::cout << it << ' ';
  }
  std::cout << '\n';
}
