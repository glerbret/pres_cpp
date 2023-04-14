#include <iostream>
#include <thread>
#include <chrono>
#include <semaphore>
 
std::binary_semaphore signalMainToThread{0};
std::binary_semaphore signalThreadToMain{0};

using namespace std::literals;

void foo()
{
  signalMainToThread.acquire();
  std::cout << "[thread] Reception du signal\n";
 
  std::this_thread::sleep_for(2s);
 
  std::cout << "[thread] Envoi a main\n";
  signalThreadToMain.release();
}
 
int main()
{
  std::thread worker(foo);
  std::this_thread::sleep_for(2s);

  std::cout << "[main] Envoi au thread\n";
  signalMainToThread.release();
  signalThreadToMain.acquire();
 
  std::cout << "[main] Got the signal\n"; // response message
  worker.join();
}
