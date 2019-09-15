#include <iostream>
#include <boost/filesystem.hpp>
#include <boost/filesystem/fstream.hpp>

int main()
{
  boost::filesystem::path cwd = boost::filesystem::current_path();
  std::cout << cwd.string() << '\n';

  {
    boost::filesystem::ofstream file(cwd / "test.txt");
    file << "Coucou" << '\n';
  }

  getchar();

  boost::filesystem::rename(cwd / "test.txt", cwd / "toto.txt");

  getchar();

  boost::filesystem::path output_directory = cwd / "output" / "sample";
  boost::filesystem::create_directories(output_directory);
  boost::filesystem::copy(cwd / "toto.txt", output_directory / "toto.txt");

  getchar();

  boost::filesystem::remove_all(cwd / "output");
  boost::filesystem::remove(cwd / "toto.txt");
}
