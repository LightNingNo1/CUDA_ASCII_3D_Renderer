
#ifndef CUDA_ASCII_3D_RENDERER_SPHERE_CUH
#define CUDA_ASCII_3D_RENDERER_SPHERE_CUH
#include "math/Ray.cuh"
#include "../Hit/HitRecord.cuh"
#include "../Hit/Hittable.cuh"
#include "../Intersection/SphereIntersection.cuh"


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
        return hitSphere(ray, SphereData(center,radius), tMin, tMax, record);
    }


};


#endif //CUDA_ASCII_3D_RENDERER_SPHERE_CUH
