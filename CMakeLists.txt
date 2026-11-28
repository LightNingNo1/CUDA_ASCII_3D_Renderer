cmake_minimum_required(VERSION 3.24)

# 项目名称
project(CUDA_ASCII_3D_Renderer LANGUAGES CXX CUDA)

# C++ 标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# CUDA 标准
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)

# RTX 5060 Laptop GPU
set(CMAKE_CUDA_ARCHITECTURES 120)

# 查找 CUDA Toolkit
find_package(CUDAToolkit REQUIRED)

# 创建可执行文件
add_executable(CUDA_ASCII_3D_Renderer
        src/main.cu
        include/math/Ray.cuh
        include/renderer/Object/Sphere.cuh
        include/renderer/Hit/HitRecord.cuh
        include/renderer/Hit/HittableList.cuh
        include/renderer/Object/Triangle.cuh
        include/math/Matrix3x3.cuh
        include/renderer/Hit/Hittable.cuh
        include/renderer/GPUScene/GPUScene.cuh
        include/renderer/GPUScene/GPUSceneUpload.cuh
        include/utils/CudaCheck.cuh
        include/renderer/GPUScene/GPUSceneBuilder.cuh
        include/renderer/GPUScene/GPUSceneManager.cuh
        include/renderer/Intersection/SphereIntersection.cuh
        include/renderer/Intersection/TriangleIntersection.cuh
        include/renderer/GPUScene/GPUSceneHit.cuh
        include/renderer/Camera/Camera.cuh
        include/renderer/Camera/GPUCameraManager.cuh
        include/renderer/RayTracingKernel.cuh
        include/renderer/Image/Pixel.cuh
)

target_include_directories(CUDA_ASCII_3D_Renderer
        PRIVATE ${CMAKE_SOURCE_DIR}/include
)

# 链接 CUDA Runtime
target_link_libraries(CUDA_ASCII_3D_Renderer
        PRIVATE CUDA::cudart
)

