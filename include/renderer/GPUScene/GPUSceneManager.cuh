//
// Created by 14427 on 2026/11/27.
//

#ifndef CUDA_ASCII_3D_RENDERER_GPUSCENEMANAGER_CUH
#define CUDA_ASCII_3D_RENDERER_GPUSCENEMANAGER_CUH
#include "GPUScene.cuh"
#include "utils/CudaCheck.cuh"
#include "GPUSceneBuilder.cuh"
#include <vector>


class GPUSceneManager {
private:
    GPUScene scene{};

    GPUScene* deviceScene = nullptr;

    int sphereCapacity = 0;
    int triangleCapacity = 0;

    template<typename T>
    void ensureCapacity(
        T*& deviceData,
        int& capacity,
        int required) {
        if (required <= capacity) {
            return;
        }

        int newCapacity = capacity == 0 ? 16 : capacity;

        while (newCapacity < required) {
            newCapacity *= 2;
        }

        T* newData = nullptr;

        CHECK(cudaMalloc(
            reinterpret_cast<void**>(&newData),
            static_cast<size_t>(newCapacity) * sizeof(T)
        ));

        if (deviceData != nullptr) {
            CHECK(cudaFree(deviceData));
        }

        deviceData = newData;
        capacity = newCapacity;

    }

    void allocateDeviceScene() {
        if (deviceScene != nullptr) {
            return;
        }

        CHECK(cudaMalloc(
            reinterpret_cast<void**>(&deviceScene),
            sizeof(GPUScene)
        ));
    }
public:

    GPUSceneManager() = default;

    // 禁止拷贝，避免两个管理器释放同一块显存
    GPUSceneManager(const GPUSceneManager&) = delete;
    GPUSceneManager& operator=(const GPUSceneManager&) = delete;

    // 释放 GPU 显存
    ~GPUSceneManager() {
        release();
    }

    // 同步 CPU 场景数据到 GPU
    void sync(
        const std::vector<SphereData>& hostSpheres,
        const std::vector<TriangleData>& hostTriangles
    ) {
        ensureCapacity(
            scene.spheres,
            sphereCapacity,
            static_cast<int>(hostSpheres.size())
        );

        ensureCapacity(
            scene.triangles,
            triangleCapacity,
            static_cast<int>(hostTriangles.size())
        );

        // 上传球体数据
        if (!hostSpheres.empty()) {
            CHECK(cudaMemcpy(
                scene.spheres,
                hostSpheres.data(),
                hostSpheres.size() * sizeof(SphereData),
                cudaMemcpyHostToDevice
            ));
        }

        // 上传三角形数据
        if (!hostTriangles.empty()) {
            CHECK(cudaMemcpy(
                scene.triangles,
                hostTriangles.data(),
                hostTriangles.size() * sizeof(TriangleData),
                cudaMemcpyHostToDevice
            ));
        }

        // 更新当前物体数量
        scene.sphereCount =
            static_cast<int>(hostSpheres.size());

        scene.triangleCount =
            static_cast<int>(hostTriangles.size());

        // 分配 GPU 端场景描述对象
        allocateDeviceScene();

        // 上传场景描述对象
        CHECK(cudaMemcpy(
            deviceScene,
            &scene,
            sizeof(GPUScene),
            cudaMemcpyHostToDevice
        ));
    }

    //从CPU场景构建并同步GPU场景
    void update(const HittableList& world) {
        std::vector<SphereData> spheres;
        std::vector<TriangleData> triangles;

        //CPU场景转换
        buildGPUSceneData(world, spheres, triangles);

        //GPU显存同步
        sync(spheres, triangles);
    }

    // 获取 GPU 场景
    GPUScene getScene() const {
        return scene;
    }

    // 获取当前容量
    int getSphereCapacity() const {
        return sphereCapacity;
    }

    int getTriangleCapacity() const {
        return triangleCapacity;
    }

    // 释放 GPU 显存
    void release() {
        if (deviceScene != nullptr) {
            CHECK(cudaFree(deviceScene));
            deviceScene = nullptr;
        }

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

        sphereCapacity = 0;
        triangleCapacity = 0;
    }

    // 获取 GPU 端场景描述对象
    const GPUScene* getDeviceScene() const {
        return deviceScene;
    }

};


#endif //CUDA_ASCII_3D_RENDERER_GPUSCENEMANAGER_CUH
