//
// Created by 14427 on 2026/11/27.
//

#ifndef CUDA_ASCII_3D_RENDERER_GPUSCENE_CUH
#define CUDA_ASCII_3D_RENDERER_GPUSCENE_CUH

#include "math/Vector3.cuh"

//GPU球体数据
struct SphereData {
    Vector3 center;
    float radius = 0.0f;

    __host__ __device__
    SphereData() = default;

    __host__ __device__
    SphereData(
        const Vector3& center,
        float radius
        ) : center(center), radius(radius) {}
};

//GPU 三角形数据
struct TriangleData {
    Vector3 v0;
    Vector3 v1;
    Vector3 v2;

    __host__ __device__
    TriangleData() = default;

    __host__ __device__
    TriangleData(
        const Vector3& v0,
        const Vector3& v1,
        const Vector3& v2
    ) : v0(v0), v1(v1), v2(v2) {}
};

struct GPUScene {
    SphereData* spheres;
    int sphereCount;

    TriangleData* triangles;
    int triangleCount;
};


#endif //CUDA_ASCII_3D_RENDERER_GPUSCENE_CUH
