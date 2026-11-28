
#ifndef CUDA_ASCII_3D_RENDERER_TRIANGLE_CUH
#define CUDA_ASCII_3D_RENDERER_TRIANGLE_CUH
#include "math/Vector3.cuh"
#include "../Hit/HitRecord.cuh"
#include "../Hit/Hittable.cuh"
#include "../Intersection/TriangleIntersection.cuh"
#include "math/Ray.cuh"
#include "math/Matrix3x3.cuh"


struct Triangle : public Hittable {
    Vector3 vertices[3];

    //构造函数
    __host__ __device__
    Triangle(const Vector3 &v0, const Vector3 &v1, const Vector3 &v2) : vertices{v0, v1, v2} {}

    //逆矩阵方法求交
    bool hit_InvMatrix(const Ray& ray,
            float tMin,
            float tMax,
            HitRecord& record) const{
        Vector3 E1(vertices[1] - vertices[0]);
        Vector3 E2(vertices[2] - vertices[0]);

        Vector3 C = ray.origin - vertices[0];

        Matrix3x3 M = Matrix3x3(ray.direction * -1.0f, E1, E2);
        Matrix3x3 M_inv = {0,0,0,0,0,0,0,0,0};

        if(!M.inverse(M_inv)) {
            return false;
        }

        Vector3 TUV = M_inv * C;

        float t = TUV.x;
        float u = TUV.y;
        float v = TUV.z;

        if (u < 0.0f || v < 0.0f || u + v > 1.0f || t < tMin || t > tMax) {
            return false;
        }

        record.t = TUV.x;
        record.point = ray.at(TUV.x);

        Vector3 normal = E1.cross(E2).normalized();

        record.frontFace = normal.dot(ray.direction) < 0.0f;
        record.normal = record.frontFace ? normal : normal * -1.0f;
        return true;

    }

    //Möller–Trumbore法求交(CPU端虚函数)
    bool hit(const Ray& ray,
            float tMin,
            float tMax,
            HitRecord& record
        ) const override {
        return hitTriangle(ray, TriangleData(vertices[0], vertices[1], vertices[2]), tMin, tMax, record);
    }

};


#endif //CUDA_ASCII_3D_RENDERER_TRIANGLE_CUH
