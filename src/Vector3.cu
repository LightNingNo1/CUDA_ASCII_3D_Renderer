#include <iostream>
#include "math/Vector3.cuh"

int main() {
    Vector3 A(1, 2, 3);
    Vector3 B(4, 5, 6);

    Vector3 C = A + B;

    std::cout << "C: " << C.x << ", " << C.y << ", " << C.z << std::endl;

    Vector3 D = A * 3;

    std::cout << "D: "<< D.x << ", " << D.y << ", " << D.z << std::endl;
    std::cout << A.length() << std::endl;
    std::cout << A.dot(B) << std::endl;
    Vector3 E = B.cross(B);

    std::cout << "E: " << E.x << ", " << E.y << ", " << E.z << std::endl;
}