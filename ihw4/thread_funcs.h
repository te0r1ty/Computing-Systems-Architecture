#include <semaphore.h>

// Variables needed in this header
extern std::vector<Pin> buffer;
extern std::vector<Pin> qualifiedBuffer;
extern int straighteners;
extern int sharpers;
extern int qualifiers;
extern int pins;
extern int curved;
extern int dull;
extern int usable;

// Counters needed for while cycles
int sharpened;
int straight;

// Semaphores
sem_t straight_pins_sem;
sem_t straight_pins_available;
sem_t sharpened_pins_sem;
sem_t sharpened_pins_available;

// Buffers
std::vector<Pin> straightBuff;
std::vector<Pin> sharpBuff;

// Mutexes
pthread_mutex_t straightMutex;
pthread_mutex_t sharpMutex;
pthread_mutex_t qualityMutex;

// Function for checking if pin is straight
void* StraightChecker(void* param) {
	// Randomize the working time
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> straightRand(2, 8);
    Sleep(straightRand(gen) * 100);
    
	// Checking the pin
    for (int i = *(int*)param; i < buffer.size(); i += straighteners) {
        if (buffer[i].isStraight()) {
            sem_wait(&straight_pins_available);
            straightBuff.push_back(buffer[i]);
            sem_post(&straight_pins_sem);
            straight++;
            continue;
        }
        curved++;
    }

	// Mutex for stable console output
    pthread_mutex_lock(&straightMutex);
    std::cout << '#' << *(int*)param + 1 << " Straightness checker ended it's job." << std::endl;
    pthread_mutex_unlock(&straightMutex);

    return nullptr;
}

// Function for making pin sharp
void* Sharpener([[maybe_unused]] void* param) {
	// Randomize the working time
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> straightRand(3, 7);
    Sleep(straightRand(gen) * 100);

	// Cycle for sharping the pins
    while (pins != curved + sharpened) {
		// Mutex for single access to the buffer
        pthread_mutex_lock(&sharpMutex);
        sem_wait(&straight_pins_sem);

		// Skipping itteration if the buffer is empty
        if (straightBuff.empty()) {
            pthread_mutex_unlock(&sharpMutex);
            continue;
        }

		// Semaphore for single access to the buffer
        sem_wait(&sharpened_pins_available);

		// Making the pin sharp randomly
        Pin tmp = straightBuff[0];
        straightBuff.erase(straightBuff.begin());
        std::uniform_int_distribution<> sharpnessRand(0, 2);
        tmp.setSharpened(sharpnessRand(gen));
        sharpened++;
        sharpBuff.push_back(tmp);
		
		// Communication with other threads
        sem_post(&straight_pins_available);
        sem_post(&sharpened_pins_sem);
        pthread_mutex_unlock(&sharpMutex);
    }

    return nullptr;
}

// Function for checking if pin is sharp
void* Qualifier([[maybe_unused]] void* param) {
	// Randomize the working time
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> straightRand(4, 6);
    Sleep(straightRand(gen) * 100);

	// Cycle for checking the pins
    while (usable + dull + curved != pins) {
		// Mutex and semaphore for single access to the buffer
        pthread_mutex_lock(&qualityMutex);
        sem_wait(&sharpened_pins_sem);

		// Skipping itteration if the buffer is empty
        if(sharpBuff.empty()) {
            pthread_mutex_unlock(&qualityMutex);
            continue;
        }

        Pin tmp = sharpBuff[0];
        sharpBuff.erase(sharpBuff.begin());

		// Next itteration if the pin is dull
        if (!tmp.isSharpened()) {
            dull++;
            sem_post(&sharpened_pins_available);
            pthread_mutex_unlock(&qualityMutex);
            continue;
        }

        tmp.setUsable(true);
        qualifiedBuffer.push_back(tmp);
        usable++;
		
		// Communication with other threads
        sem_post(&sharpened_pins_available);
        pthread_mutex_unlock(&qualityMutex);
    }

    return nullptr;
}

// Function for unlocking the threads
// if previuos threads finished their work
[[noreturn]] void* Unblocking(void* param){
    sem_t n = *(sem_t*)param;
    while (true)
        sem_post(&n);
}

// Heading function simulating the factory 
void* Factory([[maybe_unused]] void *param) {
	// Semaphores and threads initialisation
    sem_init(&straight_pins_sem, 0, 0);
    sem_init(&sharpened_pins_sem, 0, 0);
    sem_init(&straight_pins_available, 0, 1);
    sem_init(&sharpened_pins_available, 0, 1);

    pthread_mutex_init(&straightMutex, nullptr);
    pthread_mutex_init(&sharpMutex, nullptr);
    pthread_mutex_init(&qualityMutex, nullptr);

	// Starting all the threads
    int thrNum[3];
    auto* straight_threads = new pthread_t[straighteners];
    for (int i = 0; i < straighteners; ++i) {
        thrNum[i] = i;
        pthread_create(&straight_threads[i], nullptr, StraightChecker, (void*)& thrNum[i]);
    }
    std::cout << std::endl << "All straight checkers started to work" << std::endl;
    Sleep(300);

    auto* sharp_threads = new pthread_t[sharpers];
    for (int i = 0; i < sharpers; ++i) {
        pthread_create(&sharp_threads[i], nullptr, Sharpener, nullptr);
    }
    std::cout << "All sharpeners started to work" << std::endl;
    Sleep(300);
    
    auto* quality_threads = new pthread_t[qualifiers];
    for (int i = 0; i < qualifiers; ++i) {
        pthread_create(&quality_threads[i], nullptr, Qualifier, nullptr);
    }
    std::cout << "All qualifiers started to work" << std::endl << std::endl;
    Sleep(300);

	
	// Waiting for all the threads to finish their work
    for (int i = 0; i < straighteners; ++i) {
        pthread_join(straight_threads[i], nullptr);
    }
    std::cout << std::endl << "All straight checkers ended their job." << std::endl;
    pthread_t fixer1;
    pthread_create(&fixer1, nullptr, Unblocking, (void*)& straight_pins_sem);
    Sleep(300);

    for (int i = 0; i < sharpers; ++i) {
        pthread_join(sharp_threads[i], nullptr);
    }
    std::cout << "All sharpeners ended their job." << std::endl;
    pthread_t fixer2;
    pthread_create(&fixer2, nullptr, Unblocking, (void*)& sharpened_pins_sem);
    Sleep(300);

    for (int i = 0; i < qualifiers; ++i) {
        pthread_join(quality_threads[i], nullptr);
    }
    std::cout << "All quality checkers ended their job." << std::endl << std::endl;
    Sleep(300);

    return nullptr;
}
