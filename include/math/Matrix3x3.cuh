//
// Created by 14427 on 2026/11/26.
//

#ifndef CUDA_ASCII_3D_RENDERER_MATRIX3X3_CUH
#define CUDA_ASCII_3D_RENDERER_MATRIX3X3_CUH

#include <iomanip>
#include <math.h>

#include "Vector3.cuh"

struct Matrix3x3 {
    float m[3][3];

    //构造函数
    __host__ __device__
    Matrix3x3(float m00, float m01, float m02,
              float m10, float m11, float m12,
              float m20, float m21, float m22)
        : m{{m00, m01, m02},
            {m10, m11, m12},
            {m20, m21, m22}} {}

    __host__ __device__
    Matrix3x3(const Vector3 &v0, const Vector3 &v1, const Vector3 &v2)
        : m{{v0.x, v1.x, v2.x},
            {v0.y, v1.y, v2.y},
            {v0.z, v1.z, v2.z}} {}

    //求行列式
    __host__ __device__
    float determinant() const {
        return m[0][0] * (m[1][1] * m[2][2] - m[2][1] * m[1][2]) -
               m[0][1] * (m[1][0] * m[2][2] - m[2][0] * m[1][2]) +
               m[0][2] * (m[1][0] * m[2][1] - m[2][0] * m[1][1]);
    }

    //转置矩阵
    __host__ __device__
    Matrix3x3 transpose() const {
        return {
            m[0][0], m[1][0], m[2][0],
            m[0][1], m[1][1], m[2][1],
            m[0][2], m[1][2], m[2][2]
        };
    }

    //求逆矩阵
    __host__ __device__
    bool inverse(Matrix3x3 & result) const {
        // 取出矩阵元素
        float a = m[0][0];
        float b = m[0][1];
        float c = m[0][2];

        float d = m[1][0];
        float e = m[1][1];
        float f = m[1][2];

        float g = m[2][0];
        float h = m[2][1];
        float i = m[2][2];

        // 计算行列式
        float det = determinant();

        if (det == 0.0f) {
            return false;
        }

        // 矩阵近似奇异性检测
        float scale = 0.0f;

        for (int row = 0; row < 3; row++) {
            for (int col = 0; col < 3; col++) {
                float value = fabsf(m[row][col]);
                if (value > scale) {
                    scale = value;
                }
            }
        }

        if (scale == 0.0f ||
            fabsf(det) <= 1e-8f * scale * scale * scale) {
            return false;
            }

        float invDet = 1.0f / det;

        // 计算伴随矩阵，并除以行列式
        result = Matrix3x3(
            (e * i - f * h) * invDet,
            (c * h - b * i) * invDet,
            (b * f - c * e) * invDet,

            (f * g - d * i) * invDet,
            (a * i - c * g) * invDet,
            (c * d - a * f) * invDet,

            (d * h - e * g) * invDet,
            (b * g - a * h) * invDet,
            (a * e - b * d) * invDet
        );

        return true;
    }

    //矩阵乘向量
    __host__ __device__
    Vector3 operator*(const Vector3 & v) const{
        return {
            m[0][0] * v.x + m[0][1] * v.y + m[0][2] * v.z,
            m[1][0] * v.x + m[1][1] * v.y + m[1][2] * v.z,
            m[2][0] * v.x + m[2][1] * v.y + m[2][2] * v.z
        };
    }

    //矩阵乘矩阵
    __host__ __device__
    Matrix3x3 operator*(const Matrix3x3 & b) const{
        return { *this * Vector3(b.m[0][0], b.m[1][0], b.m[2][0]),
                    *this * Vector3(b.m[0][1], b.m[1][1], b.m[2][1]),
                    *this * Vector3(b.m[0][2], b.m[1][2], b.m[2][2])
        };
    }

};

// inline std::ostream& operator<<(std::ostream& os, const Matrix3x3& m) {
//     os << "( " << m.m[0][0] << ", " << m.m[0][1] << ", " << m.m[0][2] << ")" << std::endl;
//     os << "( " << m.m[1][0] << ", " << m.m[1][1] << ", " << m.m[1][2] << ")" << std::endl;
//     os << "( " << m.m[2][0] << ", " << m.m[2][1] << ", " << m.m[2][2] << ")" << std::endl;
//     return os;
// }

inline std::ostream& operator<<(std::ostream& os, const Matrix3x3& m) {
    for (auto i : m.m) {
        os << "( ";
        for (int j = 0; j < 3; ++j) {
            os << std::setw(3) << i[j];
            if (j < 2) {
                os << ", ";
            }
        }
        os << " )" << std::endl;
    }

    return os;
}


#endif //CUDA_ASCII_3D_RENDERER_MATRIX3X3_CUH
