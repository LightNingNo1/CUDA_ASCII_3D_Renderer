//
// Created by 14427 on 2026/11/28.
//

#ifndef CUDA_ASCII_3D_RENDERER_GPUCAMERAMANAGER_CUH
#define CUDA_ASCII_3D_RENDERER_GPUCAMERAMANAGER_CUH


#include <iostream>

#include <cuda_runtime.h>

#include "Camera.cuh"
#include "utils/CudaCheck.cuh"

class GPUCameraManager {
private:
    // GPU端相机数据指针
    CameraData* deviceCamera;

public:
    // 构造函数
    GPUCameraManager()
        : deviceCamera(nullptr)
    {}

    // 禁止拷贝，避免重复释放GPU内存
    GPUCameraManager(const GPUCameraManager&) = delete;
    GPUCameraManager& operator=(const GPUCameraManager&) = delete;

    // 析构函数
    ~GPUCameraManager() {
        release();
    }

    // 分配GPU内存
    void allocate() {
        if (deviceCamera != nullptr) {
            return;
        }

        CHECK(cudaMalloc(
            reinterpret_cast<void**>(&deviceCamera),
            sizeof(CameraData)
        ));

    }

    // 将CPU相机数据同步到GPU
    void upload(const CameraData& camera) {
        allocate();

        CHECK(cudaMemcpy(
            deviceCamera,
            &camera,
            sizeof(CameraData),
            cudaMemcpyHostToDevice
        ));
    }

    // 释放GPU内存
    void release() {
        if (deviceCamera != nullptr) {

            CHECK(cudaFree(deviceCamera));

            deviceCamera = nullptr;
        }
    }

    // 获取GPU相机指针
    CameraData* getDeviceCamera() const {
        return deviceCamera;
    }
};


#endif //CUDA_ASCII_3D_RENDERER_GPUCAMERAMANAGER_CUH
