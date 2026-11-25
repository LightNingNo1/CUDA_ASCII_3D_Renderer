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
        src/Vector3.cu
)

target_include_directories(CUDA_ASCII_3D_Renderer
        PRIVATE ${CMAKE_SOURCE_DIR}/include
)

# 链接 CUDA Runtime
target_link_libraries(CUDA_ASCII_3D_Renderer
        PRIVATE CUDA::cudart
)

