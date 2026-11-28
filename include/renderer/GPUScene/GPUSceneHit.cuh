//
// Created by 14427 on 2026/11/28.
//

#ifndef CUDA_ASCII_3D_RENDERER_GPUSCENEHIT_CUH
#define CUDA_ASCII_3D_RENDERER_GPUSCENEHIT_CUH


#include "GPUScene.cuh"
#include "../Hit/HitRecord.cuh"

#include "../Intersection/SphereIntersection.cuh"
#include "../Intersection/TriangleIntersection.cuh"

__device__
inline bool hitGPUScene(
    const GPUScene& scene,
    const Ray& ray,
    float tMin,
    float tMax,
    HitRecord& record
) {
    bool hitAnything = false;

    float closestSoFar = tMax;

    HitRecord tempRecord;

    // 遍历所有球体
    for (int i = 0; i < scene.sphereCount; ++i) {

        if (hitSphere(
            ray,
            scene.spheres[i],
            tMin,
            closestSoFar,
            tempRecord
        )) {
            hitAnything = true;

            closestSoFar = tempRecord.t;

            record = tempRecord;
        }
    }

    // 遍历所有三角形
    for (int i = 0; i < scene.triangleCount; ++i) {

        if (hitTriangle(
            ray,
            scene.triangles[i],
            tMin,
            closestSoFar,
            tempRecord
        )) {
            hitAnything = true;

            closestSoFar = tempRecord.t;

            record = tempRecord;
        }
    }

    return hitAnything;
}


#endif //CUDA_ASCII_3D_RENDERER_GPUSCENEHIT_CUH
