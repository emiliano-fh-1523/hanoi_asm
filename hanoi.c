#include <stdio.h>

void hanoi(int n, char source, char destination, char auxiliary) {
    if (n > 0) {
        hanoi(n - 1, source, auxiliary, destination);
        hanoi(n - 1, auxiliary, destination, source);
    }
}

int main() {
    hanoi(3, 'A', 'C', 'B');
    return 0;
}