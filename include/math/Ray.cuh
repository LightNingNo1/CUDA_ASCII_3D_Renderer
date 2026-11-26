
#ifndef CUDA_ASCII_3D_RENDERER_RAY_CUH
#define CUDA_ASCII_3D_RENDERER_RAY_CUH
#include "Vector3.cuh"


struct Ray {
    Vector3 origin;     //起点
    Vector3 direction;  //方向

    //构造函数
    __host__ __device__
    Ray(const Vector3& origin, const Vector3& direction): origin(origin), direction(direction) {}

    //射线位置计算
    __host__ __device__
    Vector3 at(float t) const {
        return origin + direction * t;
    }


};


#endif //CUDA_ASCII_3D_RENDERER_RAY_CUH
