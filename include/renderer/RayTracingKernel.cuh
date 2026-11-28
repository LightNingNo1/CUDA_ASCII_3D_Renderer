//
// Created by 14427 on 2026/11/28.
//

#ifndef CUDA_ASCII_3D_RENDERER_RAYTRACINGKERNEL_CUH
#define CUDA_ASCII_3D_RENDERER_RAYTRACINGKERNEL_CUH


#include <cfloat>

#include "Camera/Camera.cuh"
#include "math/Ray.cuh"
#include "GPUScene/GPUScene.cuh"
#include "GPUScene/GPUSceneHit.cuh"
#include "Hit/HitRecord.cuh"
#include "Image/Pixel.cuh"

// 每个线程负责一个像素的射线求交
__global__
void rayHitTestKernel(
    const CameraData* camera,
    const GPUScene* scene,
    Pixel* pixels,
    int imageWidth,
    int imageHeight
) {
    // 获取当前线程对应的像素坐标
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    // 越界检查
    if (x >= imageWidth || y >= imageHeight) {
        return;
    }

    // 二维像素坐标转换为一维索引
    int index = y * imageWidth + x;

    Ray ray(Vector3(0,0,0), Vector3(0,0,1));

    // 生成当前像素对应的射线
    camera->getRayFromPixel(x, y,
        imageWidth,
        imageHeight,
        ray
    );

    // 当前线程独立的求交记录
    HitRecord record;

    // 执行场景求交
    bool hit = hitGPUScene(
        *scene,
        ray,
        0.001f,
        FLT_MAX,
        record
    );

    uint8_t k = 0.0f;

    if (hit) {
        float brightness = 1.0f - (record.t - 4.0f) / 3.0f;

        brightness = fminf(fmaxf(brightness, 0.0f), 1.0f);

        k = static_cast<unsigned char>(255.0f * brightness);
    }

    pixels[index] = hit ? Pixel(k, k, k) : Pixel(0, 0, 0);
}


#endif //CUDA_ASCII_3D_RENDERER_RAYTRACINGKERNEL_CUH
