
#include <iostream>
#include <vector>
#include <cstdio>

#include "renderer/GPUSceneManager.cuh"
#include "renderer/GPUSceneHit.cuh"

// GPU 求交测试 Kernel
__global__ void testIntersection(
    GPUScene scene,
    Ray ray,
    int rayID
) {
    if (blockIdx.x != 0 || threadIdx.x != 0) {
        return;
    }

    HitRecord record;

    bool hit = hitGPUScene(
        scene,
        ray,
        0.001f,
        1000.0f,
        record
    );

    if (hit) {
        printf("Ray %d: Hit!\n", rayID);

        printf("t = %.4f\n", record.t);

        printf(
            "Point = (%.4f, %.4f, %.4f)\n",
            record.point.x,
            record.point.y,
            record.point.z
        );

        printf(
            "Normal = (%.4f, %.4f, %.4f)\n",
            record.normal.x,
            record.normal.y,
            record.normal.z
        );

        printf(
            "Front Face = %d\n",
            record.frontFace
        );
    }
    else {
        printf("Ray %d: Miss!\n", rayID);
    }
}

int main() {
    // 1. 构建 CPU 场景
    HittableList world;

    world.add(std::make_shared<Sphere>(
        Vector3(0, 0, -5),
        1.0f
    ));

    world.add(std::make_shared<Triangle>(
        Vector3(2, -1, -8),
        Vector3(4, -1, -8),
        Vector3(3, 1, -8)
    ));

    // 2. 构建 GPU 场景
    GPUSceneManager manager;

    manager.update(world);

    GPUScene scene = manager.getScene();

    // 3. 测试球体
    Ray sphereRay(
        Vector3(0, 0, 0),
        Vector3(0, 0, -1)
    );

    testIntersection<<<1, 1>>>(
        scene,
        sphereRay,
        0
    );

    CHECK_KERNEL();

    // 4. 测试三角形
    Ray triangleRay(
        Vector3(3, 0, 0),
        Vector3(0, 0, -1)
    );

    testIntersection<<<1, 1>>>(
        scene,
        triangleRay,
        1
    );

    CHECK_KERNEL();

    return 0;
}
