
#include <iostream>
#include <vector>
#include <memory>

#include "renderer/GPUSceneBuilder.cuh"
#include "renderer/GPUSceneUpload.cuh"

int main() {
    // 1. 创建 CPU 场景
    HittableList world;

    world.add(std::make_shared<Sphere>(
        Vector3(0, 0, -5),
        1.0f
    ));

    world.add(std::make_shared<Sphere>(
        Vector3(2, 0, -5),
        0.5f
    ));

    world.add(std::make_shared<Triangle>(
        Vector3(-1, -1, -8),
        Vector3(1, -1, -8),
        Vector3(0, 1, -8)
    ));

    // 2. 准备 GPU 数据容器
    std::vector<SphereData> spheres;
    std::vector<TriangleData> triangles;

    // 3. 从 CPU 场景提取数据
    buildGPUSceneData(
        world,
        spheres,
        triangles
    );

    // 4. 查看转换结果
    std::cout << "Sphere count: "
              << spheres.size() << std::endl;

    std::cout << "Triangle count: "
              << triangles.size() << std::endl;

    // 5. 上传 GPU
    GPUScene scene{};

    uploadGPUScene(
        spheres,
        triangles,
        scene
    );

    std::cout << "GPU Scene uploaded successfully!"
              << std::endl;

    // 6. 释放 GPU 显存
    releaseGPUScene(scene);

    return 0;
}
