
#ifndef CUDA_ASCII_3D_RENDERER_SPHERE_CUH
#define CUDA_ASCII_3D_RENDERER_SPHERE_CUH
#include "math/Ray.cuh"
#include "HitRecord.cuh"
#include "Hittable.cuh"


struct Sphere : public Hittable{
    Vector3 center;        //球心
    float radius;          //半径

    //构造函数
    __host__ __device__
    Sphere(const Vector3& center, float radius): center(center), radius(radius) {}

    //判断射线是否与球体相交(CPU端虚函数)
    bool hit(const Ray& ray,
            float tMin,
            float tMax,
            HitRecord& record
            ) const override {
        return hitDevice(ray, tMin, tMax, record);
    }

    //判断射线是否与球体相交(GPU端)
    __host__ __device__
    bool hitDevice(const Ray& ray,
            float tMin,
            float tMax,
            HitRecord& record
            ) const {
        //移动坐标系
        Vector3 oc = ray.origin - center;

        float a = ray.direction.dot(ray.direction);
        float b = 2.0f * oc.dot(ray.direction);
        float c = oc.dot(oc) - radius * radius;

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

        Vector3 normal = (record.point - center).normalized();  //交点表面法线

        record.frontFace = ray.direction.dot(normal) < 0.0f;    //判断是否是正面击中

        record.normal = record.frontFace ? normal : normal * -1.0f;     //写入法向量


        return true;
    }
};


#endif //CUDA_ASCII_3D_RENDERER_SPHERE_CUH
