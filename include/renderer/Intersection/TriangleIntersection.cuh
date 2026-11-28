//
// Created by 14427 on 2026/11/28.
//

#ifndef CUDA_ASCII_3D_RENDERER_TRIANGLEINTERSECTION_CUH
#define CUDA_ASCII_3D_RENDERER_TRIANGLEINTERSECTION_CUH

#include "../Hit/HitRecord.cuh"

#include "math/ray.cuh"
#include "../GPUScene/GPUScene.cuh"


//Möller–Trumbore法求交
__host__ __device__
inline bool hitTriangle(const Ray& ray,
        const TriangleData& triangle,
        float tMin,
        float tMax,
        HitRecord& record
        ){
    Vector3 E1 = triangle.v1 - triangle.v0;
    Vector3 E2 = triangle.v2 - triangle.v0;
    Vector3 C = ray.origin - triangle.v0;

    float det = - E1.cross(E2).dot(ray.direction);
    if (fabsf(det) < 1e-8f) {
        return false;
    }

    float t = C.cross(E1).dot(E2) / det;
    float u = - ray.direction.cross(C).dot(E2) / det;
    float v = - ray.direction.cross(E1).dot(C) / det;

    if (t < tMin || t > tMax || u < 0.0f || v < 0.0f || u + v > 1.0f) {
        return false;
    }

    record.t = t;
    record.point = ray.at(t);
    Vector3 normal = E1.cross(E2).normalized();
    record.frontFace = normal.dot(ray.direction) < 0.0f;
    record.normal = record.frontFace ? normal : normal * -1.0f;
    return true;
}


#endif //CUDA_ASCII_3D_RENDERER_TRIANGLEINTERSECTION_CUH
