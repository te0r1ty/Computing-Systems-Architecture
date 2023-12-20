// Sharpness state class
enum class Sharp : int {Dull = 0, Sharp = 1, VerySharp = 2};

// Implementation of pin class
class Pin {
private:
    bool usable;
    bool straight;
    Sharp sharpness;
public:
    explicit Pin(bool straight) {
        this->usable = false;
        this->straight = straight;
        this->sharpness = Sharp::Dull;
    }
    void setUsable(bool val) {
        this->usable = val;
    }
    [[nodiscard]] bool isStraight() const {
        return this->straight;
    }
    [[nodiscard]] int isSharpened() const {
        return (int)this->sharpness;
    }
    void setSharpened(int val) {
        this->sharpness = (Sharp)val;
    }
    virtual ~Pin() = default;
};
