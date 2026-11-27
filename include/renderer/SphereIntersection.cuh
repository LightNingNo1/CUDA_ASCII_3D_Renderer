//
// Created by 14427 on 2026/11/28.
//

#ifndef CUDA_ASCII_3D_RENDERER_SPHEREINTERSECTION_CUH
#define CUDA_ASCII_3D_RENDERER_SPHEREINTERSECTION_CUH
#include "Hitrecord.cuh"

#include "math/ray.cuh"
#include <renderer/GPUScene.cuh>



//判断射线是否与球体相交(GPU端)
__host__ __device__
inline bool hitSphere(const Ray& ray,
            const SphereData& sphere,
            float tMin,
            float tMax,
            HitRecord& record
            ) {
    //移动坐标系
    Vector3 oc = ray.origin - sphere.center;

    float a = ray.direction.dot(ray.direction);
    float b = 2.0f * oc.dot(ray.direction);
    float c = oc.dot(oc) - sphere.radius * sphere.radius;

    float delta = b * b - 4.0f * a * c;

    const float epsilon = 1e-5f;

    if (delta < -epsilon) { return false; }

    if (delta < 0.0f) {
        delta = 0.0f;
    }

    float sqrtDelta = sqrtf(delta);

    //交点1
    float root = (-b - sqrtDelta) / (2.0f * a);

    if (root < tMin || root > tMax) {
        root = (-b + sqrtDelta) / (2.0f * a);
        if (root < tMin || root > tMax) {
            return false;
        }
    }

    record.t = root;    //写入交点参数

    record.point = ray.at(root);    //交点坐标

    Vector3 normal = (record.point - sphere.center).normalized();  //交点表面法线

    record.frontFace = ray.direction.dot(normal) < 0.0f;    //判断是否是正面击中

    record.normal = record.frontFace ? normal : normal * -1.0f;     //写入法向量


    return true;
}


#endif //CUDA_ASCII_3D_RENDERER_SPHEREINTERSECTION_CUH
