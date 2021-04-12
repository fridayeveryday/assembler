#include <iostream>

using namespace std;

int function(int x1, int x2, int x3, int x4) {
    return (x1 && x2 && x3) || (x2 && !x3 && x4) || (!x1 && !x2)
           || (x1 && !x2 && x3 && !x4) || (x3 && x4);
}

int main() {
    std::cout << "x1|x2|x3|x4 |res" << std::endl;
    for (int i = 0; i < 2; ++i) {
        for (int j = 0; j < 2; ++j) {
            for (int k = 0; k < 2; ++k) {
                for (int l = 0; l < 2; ++l) {
                    std::cout << i << "  " << j << "  " << k << "  " << l << "  | " << function(i, j, k, l) << "\n";
                }
            }
        }
    }
    return 0;
}
