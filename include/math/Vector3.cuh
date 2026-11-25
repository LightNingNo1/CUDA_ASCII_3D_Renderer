#ifndef CUDA_ASCII_3D_RENDERER_VECTOR3_CUH
#define CUDA_ASCII_3D_RENDERER_VECTOR3_CUH

#include <cmath>

struct Vector3 {

    float x, y, z;

    //默认构造函数
    __host__ __device__
    Vector3(): x(0), y(0), z(0) {}

    //带参数传入的构造函数
    __host__ __device__
    Vector3(float x, float y, float z) : x(x), y(y), z(z) {}

    //向量加法
    __host__ __device__
    Vector3 operator+(const Vector3& v) const {
        return {x + v.x, y + v.y, z + v.z};
    }

    //向量减法
    __host__ __device__
    Vector3 operator-(const Vector3&v) const {
        return {x - v.x, y - v.y, z - v.z};
    }

    //向量数乘
    __host__ __device__
    Vector3 operator*(float k) const {
        return {k * x, k * y, k * z};
    }

    //向量点乘
    __host__ __device__
    float dot(const Vector3& v) const {
        return x * v.x + y * v.y + z * v.z;
    }

    //向量叉乘
    __host__ __device__
    Vector3 cross(const Vector3& v) const {
        return {y * v.z - z * v.y,
                       z * v.x - x * v.z,
                       x * v.y - y * v.x};
    }

    //向量模长平方
    __host__ __device__
    float lengthSquared() const {
        return dot(*this);
    }

    //向量模长
    __host__ __device__
    float length() const {
        return sqrt(lengthSquared());
    }

    //向量归一化
    __host__ __device__
    Vector3 normalized() const {
        float len = length();
        if (len < 1e-8f) {
            return {0, 0, 0};
        }
        return {x / len, y / len, z / len};
    }

};


#endif //CUDA_ASCII_3D_RENDERER_VECTOR3_CUH
