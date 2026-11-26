
#include <iostream>
#include <memory>

#include "math/Vector3.cuh"
#include "math/Ray.cuh"

#include "renderer/Sphere.cuh"
#include "renderer/Triangle.cuh"
#include "renderer/HittableList.cuh"
#include "renderer/HitRecord.cuh"

int main() {

    HittableList world;

    // 添加一个球体
    world.add(std::make_shared<Sphere>(
        Vector3(0, 0, -5),
        1.0f
    ));

    // 添加一个三角形
    world.add(std::make_shared<Triangle>(
        Vector3(-2, -1, -8),
        Vector3( 2, -1, -8),
        Vector3( 0,  2, -8)
    ));

    // 创建射线
    Ray ray(
        Vector3(0, 0, 0),
        Vector3(0, 0, -1)
    );

    HitRecord record;

    bool isHit = world.hit(
        ray,
        0.001f,
        1000.0f,
        record
    );

    if (isHit) {
        std::cout << "Hit!" << std::endl;
        std::cout << "t = " << record.t << std::endl;
        std::cout << "Point = " << record.point << std::endl;
        std::cout << "Normal = " << record.normal << std::endl;
        std::cout << "Front Face = " << record.frontFace << std::endl;
    } else {
        std::cout << "Miss!" << std::endl;
    }

    return 0;
}
