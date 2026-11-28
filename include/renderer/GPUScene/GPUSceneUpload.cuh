//
// Created by 14427 on 2026/11/27.
//

#ifndef CUDA_ASCII_3D_RENDERER_GPUSCENEUPLOAD_CUH
#define CUDA_ASCII_3D_RENDERER_GPUSCENEUPLOAD_CUH

#include <vector>
#include <cuda_runtime.h>
#include "GPUScene.cuh"
#include "utils/CudaCheck.cuh"

//CPU -> GPU

template<typename T>
void uploadArray(
    const std::vector<T>& hostData,
    T* &deviceData
    ) {
    deviceData = nullptr;

    if (hostData.empty()) {
        return;
    }

    size_t size = hostData.size() * sizeof(T);

    CHECK(cudaMalloc(reinterpret_cast<void**>(&deviceData), size));

    CHECK(cudaMemcpy(deviceData, hostData.data(), size, cudaMemcpyHostToDevice));

}


inline void uploadGPUScene(
    const std::vector<SphereData>& hostSpheres,
    const std::vector<TriangleData>& hostTriangles,
    GPUScene& scene
) {
    scene.spheres = nullptr;
    scene.sphereCount = 0;
    scene.triangles = nullptr;
    scene.triangleCount = 0;

    uploadArray(hostSpheres, scene.spheres);
    uploadArray(hostTriangles, scene.triangles);

    scene.sphereCount = static_cast<int>(hostSpheres.size());
    scene.triangleCount = static_cast<int>(hostTriangles.size());
}

// 释放 GPU 场景显存
inline void releaseGPUScene(GPUScene& scene) {
    if (scene.spheres != nullptr) {
        CHECK(cudaFree(scene.spheres));
        scene.spheres = nullptr;
    }

    if (scene.triangles != nullptr) {
        CHECK(cudaFree(scene.triangles));
        scene.triangles = nullptr;
    }

    scene.sphereCount = 0;
    scene.triangleCount = 0;
}

#endif //CUDA_ASCII_3D_RENDERER_GPUSCENEUPLOAD_CUH
