//
// Created by 14427 on 2026/11/27.
//

#ifndef CUDA_ASCII_3D_RENDERER_GPUSCENEBUILDER_CUH
#define CUDA_ASCII_3D_RENDERER_GPUSCENEBUILDER_CUH

#include <vector>
#include <memory>

#include "renderer/HittableList.cuh"
#include "renderer/Sphere.cuh"
#include "renderer/Triangle.cuh"
#include "renderer/GPUScene.cuh"

// 将 CPU 场景转换为 GPU 几何数据
inline void buildGPUSceneData(
    const HittableList& world,
    std::vector<SphereData>& spheres,
    std::vector<TriangleData>& triangles
) {
    // 清空旧数据
    spheres.clear();
    triangles.clear();

    // 遍历 CPU 场景中的所有物体
    for (const auto& object : world.objects) {

        // 判断是否为 Sphere
        if (const auto* sphere =
            dynamic_cast<const Sphere*>(object.get())) {

            spheres.emplace_back(
                sphere->center,
                sphere->radius
            );

            continue;
            }

        // 判断是否为 Triangle
        if (const auto* triangle =
            dynamic_cast<const Triangle*>(object.get())) {

            triangles.emplace_back(
                triangle->vertices[0],
                triangle->vertices[1],
                triangle->vertices[2]
            );

            continue;
            }
    }
}

class GPUSceneBuilder {
};


#endif //CUDA_ASCII_3D_RENDERER_GPUSCENEBUILDER_CUH
