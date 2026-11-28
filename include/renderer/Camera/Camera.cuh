//
// Created by 14427 on 2026/11/28.
//

#ifndef CUDA_ASCII_3D_RENDERER_CAMERA_CUH
#define CUDA_ASCII_3D_RENDERER_CAMERA_CUH


#include "math/Vector3.cuh"
#include "math/Ray.cuh"

// CPU / GPU 共用的相机参数
struct CameraData {

    // 相机位置
    Vector3 position;

    // 相机观察目标
    Vector3 target;

    // 世界坐标系上方向
    Vector3 worldUp;

    // 垂直视场角，单位：度
    float vfov;

    // 图像宽高比
    float aspectRatio;

    //相机局部坐标系
    Vector3 forward;          //上
    Vector3 right;            //右
    Vector3 up;               //下

    float focalLength;       //焦距
    Vector3 lowerLeft;       //视口左下角位置
    Vector3 horizontal;      //水平向量
    Vector3 vertical;        //垂直向量

    __host__ __device__
    __host__ __device__
    CameraData()
        : position(0.0f, 0.0f, 0.0f),
          target(0.0f, 0.0f, -1.0f),
          worldUp(0.0f, 1.0f, 0.0f),
          vfov(90.0f),
          aspectRatio(16.0f / 9.0f),
          forward(0.0f, 0.0f, -1.0f),
          right(1.0f, 0.0f, 0.0f),
          up(0.0f, 1.0f, 0.0f),
          focalLength(1.0f),
          lowerLeft(-16.0f / 9.0f, -1.0f, -1.0f),
          horizontal(32.0f / 9.0f, 0.0f, 0.0f),
          vertical(0.0f, 2.0f, 0.0f)
    {}

    // __host__ __device__
    // CameraData(
    //     const Vector3& position,
    //     const Vector3& target,
    //     const Vector3& worldUp,
    //     float vfov,
    //     float aspectRatio
    // )
    //     : position(position),
    //       target(target),
    //       worldUp(worldUp),
    //       vfov(vfov),
    //       aspectRatio(aspectRatio) {}

    __host__ __device__
    bool buildCoordinateSystem() {
        //Forward
        Vector3 f = target - position;

        float f2 = f.dot(f);

        if (f2 < 1e-12f) {
            return false;
        }

        f = f * (1.0f / sqrtf(f2));

        // 2. 计算 Right
        Vector3 r = f.cross(worldUp);

        float r2 = r.dot(r);

        if (r2 < 1e-12f) {
            return false;
        }

        r = r * (1.0f / sqrtf(r2));

        // 3. 计算 Up
        Vector3 u = r.cross(f);

        float u2 = u.dot(u);

        if (u2 < 1e-12f) {
            return false;
        }

        u = u * (1.0f / sqrtf(u2));

        // 4. 全部计算成功后再更新成员
        forward = f;
        right = r;
        up = u;

        return true;
    }

    __host__ __device__
    bool buildViewport() {
        if (vfov <= 0.0f || vfov >= 180.0f) {
            return false;
        }

        if (aspectRatio <= 0.0f || focalLength <= 0.0f) {
            return false;
        }

        const float PI = 3.14159265358979323846f;

        float theta = vfov * (PI / 180.0f);

        float viewportHeight =
            2.0f * focalLength * tanf(theta / 2.0f);

        float viewportWidth =
            viewportHeight * aspectRatio;

        horizontal = right * viewportWidth;
        vertical = up * viewportHeight;

        Vector3 viewportCenter =
            position + forward * focalLength;

        lowerLeft =
            viewportCenter
            - horizontal * 0.5f
            - vertical * 0.5f;

        return true;
    }


    //根据归一化屏幕坐标生成射线
    __host__ __device__
    Ray getRay(float u, float v) const {
        Vector3 pixelPosition =
            lowerLeft
            + horizontal * u
            + vertical * v;

        Vector3 direction =
            (pixelPosition - position).normalized();

        return Ray(position, direction);
    }

    //像素坐标转为归一化屏幕坐标
    __host__ __device__
    bool pixelToUV(
        int x,
        int y,
        int imageWidth,
        int imageHeight,
        float& u,
        float& v
    ) const {
        // 检查图像尺寸
        if (imageWidth <= 0 || imageHeight <= 0) {
            return false;
        }

        // 检查像素坐标
        if (x < 0 || x >= imageWidth ||
            y < 0 || y >= imageHeight) {
            return false;
            }

        // 像素中心映射到归一化坐标
        u = (static_cast<float>(x) + 0.5f)
            / static_cast<float>(imageWidth);

        v = 1.0f -
            (static_cast<float>(y) + 0.5f)
            / static_cast<float>(imageHeight);

        return true;
    }

    //像素坐标转为射线
    __host__ __device__
    bool getRayFromPixel(
        int x,
        int y,
        int imageWidth,
        int imageHeight,
        Ray& ray
    ) const {
        float u;
        float v;

        if (!pixelToUV(
            x, y,
            imageWidth, imageHeight,
            u, v
        )) {
            return false;
        }

        ray = getRay(u, v);

        return true;
    }
};


#endif //CUDA_ASCII_3D_RENDERER_CAMERA_CUH
