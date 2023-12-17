#include <iostream>
#include <pthread.h>
#include <windows.h>
#include <random>
#include <vector>

pthread_mutex_t mutex;
pthread_barrier_t barr;
const int threadNumber = 20;
std::vector<int> order(threadNumber);
std::vector<int> buffer(threadNumber * 2);

void *Gen(void *param) {    //вычисление суммы квадратов в потоке
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> timeRand(1, 7);
    std::uniform_int_distribution<> numRand(1, 20);

    int n = timeRand(gen);
    Sleep(n * 1000);

    pthread_mutex_lock(&mutex);
    int* num = (int*)param;
    std::cout << "Generated #" << *num << " number\n";
    order.push_back(*num - 1);
    *num = numRand(gen);
    pthread_mutex_unlock(&mutex);

    return nullptr;
}

void *Control(void *param) {
    while(true) {
    }
}

int main() {
    pthread_mutex_init(&mutex, nullptr);
    pthread_barrier_init(&barr, nullptr, 2);
    srand((unsigned)time(nullptr));
    int nums[threadNumber];
    for (int i = 0; i < threadNumber; ++i) {
        nums[i] = i + 1;
    }
    pthread_t generators[threadNumber];


    for (int i = 0; i < threadNumber; ++i) {
        pthread_create(&generators[i], nullptr, Gen, (void *) &nums[i]);
    }


    pthread_t controller;
    pthread_create(&controller, nullptr, Control, nullptr);


    for (auto thread : generators) {    // ожидание завершения работы дочерних потоков
        pthread_join(thread, nullptr);
    }
    for (int num : nums) {
        std::cout << num << std::endl;
    }
    return 0;
}
