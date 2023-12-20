#include <iostream>
#include <pthread.h>
#include <windows.h>
#include <random>
#include <vector>
#include "pin.h"
#include "thread_funcs.h"

std::vector<Pin> buffer;
std::vector<Pin> qualifiedBuffer;

int straighteners;
int sharpers;
int qualifiers;

int curved;
int dull;
int usable;

int pins;

int main() {
    while (!(1 <= pins && pins <= 100)) {
        std::cout << "Enter the number of pins to check from 2 to 100: ";
        std::cin >> pins;
        if (!(1 <= pins && pins <= 100)) {
            std::cout << "This amount of pins can't be checked!\n";
        }
    }
    Sleep(500);

    for (int i = 0; i < pins; ++i) {
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> straightRand(0, 4);
        buffer.emplace_back(straightRand(gen));
    }
    std::cout << "Created a pack of " << pins << " pins." << std::endl << std::endl;
    Sleep(500);


    while (!(1 <= straighteners && straighteners <= 3)) {
        std::cout << "Enter the number of straightness controllers: ";
        std::cin >> straighteners;
        if (!(1 <= straighteners && straighteners <= 3)) {
            std::cout << "Incorrect number of straightness controllers!\n";
        }
    }
    while (!(1 <= sharpers && sharpers <= 5)) {
        std::cout << "Enter the number of sharpness controllers: ";
        std::cin >> sharpers;
        if (!(1 <= sharpers && sharpers <= 5)) {
            std::cout << "Incorrect number of sharpness controllers!\n";
        }
    }
    while (!(1 <= qualifiers && qualifiers <= 2)) {
        std::cout << "Enter the number of quality controllers: ";
        std::cin >> qualifiers;
        if (!(1 <= qualifiers && qualifiers <= 2)) {
            std::cout << "Incorrect number of quality controllers!\n";
        }
    }


    pthread_t factory;
    pthread_create(&factory, nullptr, Factory, nullptr);
    pthread_join(factory, nullptr);


    std::cout << "Curved pins: " << curved << std::endl;
    std::cout << "Dull pins: " << dull << std::endl;
    std::cout << "Usable pins: " << usable << std::endl;
    std::cout << "Total pins: " << pins << std::endl;


    return 0;
}
