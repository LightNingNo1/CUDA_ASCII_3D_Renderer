//
// Created by 14427 on 2026/11/27.
//

#ifndef CUDA_ASCII_3D_RENDERER_GPUSCENEMANAGER_CUH
#define CUDA_ASCII_3D_RENDERER_GPUSCENEMANAGER_CUH
#include "GPUScene.cuh"


class GPUSceneManager {
private:
    GPUScene scene{};

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

    }

};


#endif //CUDA_ASCII_3D_RENDERER_GPUSCENEMANAGER_CUH
