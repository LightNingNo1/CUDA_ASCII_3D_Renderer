//
// Created by 14427 on 2026/11/25.
//

#ifndef CUDA_ASCII_3D_RENDERER_MAIN_CUH
#define CUDA_ASCII_3D_RENDERER_MAIN_CUH

#include <iostream>
#include <cuda_runtime.h>
#include <cstdlib>

//检查CUDA Runtime API
#define CHEAK(call)                                                             \
do {                                                                            \
    cudaError_t err = call;                                                     \
    if (err != cudaSuccess) {                                                   \
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;    \
        std::cerr << "File: " << __FILE__                                       \
        << " Line: " << __LINE__ << std::endl;                                  \
        std::exit(EXIT_FAILURE);                                                \
    }                                                                           \
}while (0)                                                                      \


//检查 Kernel 启动与执行错误(启动Kernel函数无返回值)
#define CHEAK_KERNEL()                  \
    do {                                \
        CHEAK(cudaGetLastError());      \
        CHEAK(cudaDeviceSynchronize()); \
}while (0)                              \


#endif //CUDA_ASCII_3D_RENDERER_MAIN_CUH
